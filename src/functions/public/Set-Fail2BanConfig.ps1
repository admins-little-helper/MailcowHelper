function Set-Fail2BanConfig {
    <#
    .SYNOPSIS
        Updates the fail2ban configuration of the mailcow server.

    .DESCRIPTION
        Updates the fail2ban configuration of the mailcow server.

    .PARAMETER BanTime
        Specify for how many seconds to ban a source ip.

    .PARAMETER BanTimeIncrement
        Enable or disable the ban time increment.

    .PARAMETER MaxBanTime
        The maximum ban time in seconds.

    .PARAMETER MaxAttempts
        The maximum number of attempts, before an ip gets banned.

    .PARAMETER RetryWindow
        The number of seconds of within failed attempts need to occur to be counted.

    .PARAMETER NetbanIpv4
        IPv4 subnet size to apply ban on (8-32).

    .PARAMETER NetbanIpv6
        IPv6 subnet size to apply ban on (8-128).

    .PARAMETER BlackListIpAddress
        Specify an ip address or ip network to blacklist.

    .PARAMETER WhiteListIpAddress
        Specify an ip address or ip network to whitelist.

    .PARAMETER WhiteListHostname
        Specify a hostname to whitelist.

    .PARAMETER ListOperation
        Specify an action to execute for the list record.

    .EXAMPLE
        Set-MHFail2BanConfig -BanTime 900 -BanTimeIncrement

        This will set the ban time to 900 seconds and enable the ban time imcrement.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Fail2BanConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Specify for how many seconds to ban a source ip.")]
        [System.Int32]
        $BanTime,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Enable or disable the ban time increment.")]
        [System.Management.Automation.SwitchParameter]
        $BanTimeIncrement,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The maximum ban time in seconds.")]
        [System.Int32]
        $MaxBanTime,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The maximum number of attempts, before an ip gets banned.")]
        [System.Int32]
        $MaxAttempts,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The number of seconds within failed attempts need to occur to be counted.")]
        [System.Int32]
        $RetryWindow,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "IPv4 subnet size to apply ban on (8-32).")]
        [System.Int32]
        $NetbanIpv4,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "IPv6 subnet size to apply ban on (8-128)")]
        [System.Int32]
        $NetbanIpv6,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify an ip address or ip network to blacklist.")]
        [System.Net.IPNetwork[]]
        $BlackListIpAddress,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify an ip address or ip network to whitelist.")]
        [System.Net.IPNetwork[]]
        $WhiteListIpAddress,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify an hostname to whitelist.")]
        [System.String[]]
        $WhiteListHostname,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Specify the action to execute for the list record.")]
        [ValidateSet("Append", "Overwrite", "Remove")]
        [System.String]
        $ListOperation = "Append"
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/fail2ban"
    }

    process {
        # First get the current Fail2Ban config.
        $CurrentConfig = Get-Fail2BanConfig

        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            attr  = $CurrentConfig
            items = "none"
        }
        if ($PSBoundParameters.ContainsKey("BanTime")) {
            $Body.attr.ban_time = $BanTime.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BanTimeIncrement")) {
            $Body.attr.ban_time_increment = if ($BanTimeIncrement.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MaxBanTime")) {
            $Body.attr.max_ban_time = $MaxBanTime.ToString
        }
        if ($PSBoundParameters.ContainsKey("MaxAttempts")) {
            $Body.attr.max_attempts = $MaxAttempts.ToString()
        }
        if ($PSBoundParameters.ContainsKey("RetryWindow")) {
            $Body.attr.retry_window = $RetryWindow.ToString()
        }
        if ($PSBoundParameters.ContainsKey("NetbanIpv4")) {
            $Body.attr.netban_ipv4 = $NetbanIpv4.ToString()
        }
        if ($PSBoundParameters.ContainsKey("NetbanIpv6")) {
            $Body.attr.netban_ipv6 = $NetbanIpv6.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BlackListIpAddress")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.blacklist = $Body.attr.blacklist + "`r`n" + $BlacklistIpAddressItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.blacklist = ""
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.blacklist = $Body.attr.blacklist + "`r`n" + $BlacklistIpAddressItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Replace an entry with an empty string.
                        $Body.attr.blacklist = $Body.attr.blacklist -replace $BlacklistIpAddressItem.ToString(), ""
                    }
                    break
                }
            }
        }
        if ($PSBoundParameters.ContainsKey("WhiteListIpAddress")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListIpAddressItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.whitelist = ""
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListIpAddressItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Replace an entry with an empty string.
                        $Body.attr.whitelist = $Body.attr.whitelist -replace $WhiteListIpAddressItem.ToString(), ""
                    }
                    break
                }
            }
        }
        if ($PSBoundParameters.ContainsKey("WhiteListHostname")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListHostnameItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.whitelist = ""
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListHostnameItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Replace an entry with an empty string.
                        $Body.attr.whitelist = $Body.attr.whitelist -replace $WhiteListHostnameItem.ToString(), ""
                    }
                    break
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("mailcow fail2ban config.", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailcow fail2ban config." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}
