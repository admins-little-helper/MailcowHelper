function Get-AliasMail {
    <#
    .SYNOPSIS
        Get information about one ore more alias mail addresses.

    .DESCRIPTION
        Get information about one ore more alias mail addresses.

        This function supports two parametersets.
        Parameterset one allows to specify an alias email address for parameter "Identity".
        Parameterset two allows to specify the ID of an alias for parameter "AliasID".

    .PARAMETER Identity
        The alias mail address or ID for which to get information.
        If omitted, all alias domains are returned.

    .PARAMETER AliasId
        The ID number of the alias for which to get information.
        If omitted, all aliases are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailAlias

        Returns all aliases.

    .EXAMPLE
        Get-MHMailAlias -Identity alias@example.com

        Returns information for alias@example.com

    .EXAMPLE
        Get-MHMailAlias -AliasId 158

        Returns information for the alias with ID 158.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "AliasMail", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The alias mail address or ID for which to get information.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "AliasId", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of the alias for which to get information.")]
        [System.Int64[]]
        $AliasId,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/alias/"

        switch ($PSCmdlet.ParameterSetName) {
            "AliasMail" {
                if ([System.String]::IsNullOrEmpty($Identity)) {
                    # In case no specific mailbox name/mail address was given, use "All".
                    $RequestedIdentity = "All"
                }
                else {
                    # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
                    $RequestedIdentity = foreach ($Item in $Identity) {
                        $Item.Address
                    }
                }

                break
            }
            "AliasId" {
                # Set the requsted identity to the specified alias ID number(s).
                $RequestedIdentity = foreach ($AliasIdItem in $AliasId) { $AliasIdItem.ToString() }

                break
            }
            default {
                # Should not reach this point.
                throw "Unknown parameterset identified!"
            }
        }
    }

    process {
        foreach ($RequestedIdentityItem in $RequestedIdentity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($RequestedIdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID              = $Item.id
                        InPrimaryDomain = $Item.in_primary_domain
                        Domain          = $Item.domain
                        Goto            = $Item.goto
                        PublicComment   = $Item.public_comment
                        PrivateComment  = $Item.private_comment
                        Address         = $Item.address
                        IsCatchAll      = [System.Boolean][System.Int32]$Item.is_catch_all
                        Internal        = [System.Boolean][System.Int32]$Item.internal
                        SogoVisible     = [System.Boolean][System.Int32]$Item.sogo_visible
                        SogoVisibleInt  = [System.Boolean][System.Int32]$Item.sogo_visible_int
                        Active          = [System.Boolean][System.Int32]$Item.active
                        ActiveInt       = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated     = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified    = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAlias")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}