function Get-DomainAdmin {
    <#
    .SYNOPSIS
        Get information about one or more domain admins.

    .DESCRIPTION
        Get information about one or more domain admins.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainAdmin

        Returns information for all domain admins.

    .EXAMPLE
        Get-MHDomainAdmin -Identity "MyDomainAdmin"

        Returns informatin for user with name "MyDomainAdmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The username for which to return information.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("DomainAdmin")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/domain-admin/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Append the specified string to the Uri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

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
                        Username          = $Item.username
                        SelectedDomains   = $Item.selected_domains
                        UnselectedDomains = $Item.unselected_domains
                        TfaActive         = [System.Boolean][System.Int32]$Item.tfa_active
                        TfaActiveInt      = [System.Boolean][System.Int32]$Item.tfa_active_int
                        Active            = [System.Boolean][System.Int32]$Item.active
                        ActiveInt         = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated       = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainAdmin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
