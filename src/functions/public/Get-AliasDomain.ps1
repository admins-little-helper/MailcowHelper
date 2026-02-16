function Get-AliasDomain {
    <#
    .SYNOPSIS
        Get information about one or more alias-domains.

    .DESCRIPTION
        Get information about one or more alias-domains.

    .PARAMETER Identity
        The name of the domain for which to get information.
        If omitted, all alias domains are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAliasDomain

        Returns all alias-domains.

    .EXAMPLE
        Get-MHAliasDomain -Identity alias.example.com

        Returns information for the alias-domain alias.example.com

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get information.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/alias-domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())

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
                    if ($Item.rl.value) {
                        $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                    }
                    else {
                        $RateLimit = "Unlimited"
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        AliasDomain      = $Item.alias_domain
                        TargetDomain     = $Item.target_domain
                        ParentIsBackupMX = [System.Boolean][System.Int32]$Item.parent_is_backupmx
                        Active           = [System.Boolean][System.Int32]$Item.active
                        ActiveInt        = [System.Boolean][System.Int32]$Item.active_int
                        RateLimit        = $RateLimit
                        WhenCreated      = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified     = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAliasDomain")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}