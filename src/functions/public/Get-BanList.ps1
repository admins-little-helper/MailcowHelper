function Get-BanList {
    <#
    .SYNOPSIS
        Get ban list entries from the fail2ban service.

    .DESCRIPTION
        Get ban list entries from the fail2ban service.
        This function is not using the mailcow rest API. Instead it calls the fail2ban banlist URI which can be retried using the mailcow REST API.

    .EXAMPLE
        Get-MHBanList

        Returns ban list items from mailcow"s fail2ban service.

    .INPUTS
        Nothing

    .OUTPUTS
        System.String

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-BanList.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param()

    # Get the current Fail2Ban config which includes the banlist_id value that is required to get the banlist.
    $Fail2BanConfig = Get-Fail2BanConfig -Raw

    # Prepare the banlist URI.
    $UriPath = "https://$($Script:MailcowHelperSession.ConnectParams.Computername)/f2b-banlist?id=$($Fail2BanConfig.banlist_id)"

    # Call the URI and get the result.
    Write-MailcowHelperLog -Message "Calling Uri [$UriPath]."
    $Result = Invoke-WebRequest -Uri $UriPath

    if ($null -ne $Result) {
        switch ($Result.StatusCode) {
            200 {
                if ([System.String]::IsNullOrEmpty($Result.Content)) {
                    Write-MailcowHelperLog -Message "Connection successful, but result is empty." -Level Information
                }
                else {
                    Write-MailcowHelperLog -Message "Connection successful."
                    $Result.Content
                }
                break
            }
            401 {
                Write-MailcowHelperLog -Message "Access denied / Not authorzied." -Level Warning
                break
            }
            default {
                # Return full result.
                $Result
                break
            }
        }
    }
}
