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
                PermanentBans    = $null
                ActiveBans       = $null
            }

            # Process whitelist.
            if ($null -ne $Item.whitelist) {
                $ConvertedItem.WhiteList = $Item.whitelist -split "`n"
            }

            # Process blacklist.
            if ($null -ne $Item.Blacklist) {
                $ConvertedItem.Blacklist = $Item.blacklist -split "`n"
            }

            # Process permanent bans.
            if ($null -ne $Item.perm_bans) {
                $ConvertedItem.PermanentBans = foreach ($PermanentBanItem in $Item.perm_bans) {
                    # Return the information as custom object.
                    [PSCustomObject]@{
                        NetworkAddress = $PermanentBanItem.network
                        IPAddress      = $PermanentBanItem.ip
                    }
                }
            }
            else {
                Write-MailcowHelperLog -Message "No permanent bans returned."
                if ($null -ne $Item.blacklist) {
                    # Something is wrong - if the blacklist contains entries (=permanent bans), then "perm_bans" should also
                    # have entries (except a short moment after (re-)starting the netfilter container).
                    Write-MailcowHelperLog -Message "Blacklist has entries, while 'PermanentBans' does not. Check your configuration!" -Level Warning
                }
            }

            # Process active bans.
            if ($null -ne $Item.active_bans) {
                $ConvertedItem.ActiveBans = foreach ($ActiveBanItem in $Item.active_bans) {
                    # Extract hours, minutes and seconds value from timespan string.
                    try {
                        $BannedTimespanValues = ($ActiveBanItem.banned_until -replace "[hms]", "") -split " "
                        $BannedTimeSpan = New-TimeSpan -Hours $BannedTimespanValues[0] -Minutes $BannedTimespanValues[1] -Seconds $BannedTimespanValues[2]
                    }
                    catch {
                        $BannedTimeSpan = New-TimeSpan -Hours 0
                    }

                    # Return the calculated information.
                    [PSCustomObject]@{
                        NetworkAddress = $ActiveBanItem.network
                        IPAddress      = $ActiveBanItem.ip
                        QueuedForUnban = [System.Boolean]$ActiveBanItem.queued_for_unban
                        BannedUntil    = $ActiveBanItem.banned_until
                        BannedUntilDT  = (Get-Date).Add($BannedTimeSpan)
                    }
                }
            }
            else {
                Write-MailcowHelperLog -Message "No active bans returned."
            }

            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHFail2BanConfig")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}
