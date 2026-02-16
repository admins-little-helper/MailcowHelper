function Get-Admin {
    <#
    .SYNOPSIS
        Get information about one or more admin user accounts.

    .DESCRIPTION
        Get information about one or more admin user accounts.

    .PARAMETER Identity
        The username of the admin account for which to get information.
        If omitted, all admin user accounts are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAdmin

        Returns all admin user accounts.

    .EXAMPLE
        Get-MHAdmin -Identity superadmin

        Returns information about the admin user "superadmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The username of the admin account for which to get information.")]
        [Alias("Username")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/admin/"
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
                    $ConvertedItem = [PSCustomObject]@{
                        Username     = $Item.username
                        TfaActive    = [System.Boolean][System.Int32]$Item.tfa_active
                        TfaActiveInt = [System.Boolean][System.Int32]$Item.tfa_active_int
                        Active       = [System.Boolean][System.Int32]$Item.active
                        ActiveInt    = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAdmin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}