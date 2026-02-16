function Get-Fail2BanConfig {
    <#
    .SYNOPSIS
        Returns the fail2ban configuration of the mailcow server.

    .DESCRIPTION
        Returns the fail2ban configuration of the mailcow server.

    .EXAMPLE
        Get-MHFail2BanConfig

        Returns the fail2ban configuration of the mailcow server.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Fail2BanConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/fail2ban"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                BanTime          = $Item.ban_time
                BanTimeIncrement = $Item.ban_time_increment
                MaxBanTime       = $Item.max_ban_time
                NetBanIpv4       = $Item.netban_ipv4
                NetBanIpv6       = $Item.netban_ipv6
                MaxAttempts      = $Item.max_attempts
                RetryWindow      = $Item.retry_window
                BanlistID        = $Item.banlist_id
                Regex            = $Item.regex
                WhiteList        = $Item.whitelist
                BlackList        = $Item.blacklist

            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHFail2BanConfig")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}
