function Get-Log {
    <#
    .SYNOPSIS
        Get mailcow server logs of the specified type.

    .DESCRIPTION
        Get mailcow server logs of the specified type.

    .PARAMETER Logtype
        Specify the type of log to return. Supported values are:
        Acme, Api, Autodiscover, Dovecot, Netfilter, Postfix, RateLimited, Rspamd-History, Sogo, Watchdog

    .PARAMETER Count
        The number of logs records to return. This always returns the latest (newest) log records.

    .PARAMETER SortDesending
        Sort log output in descending order by date.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHLog -LogType "Acme" -Count 100

        Get the last 100 records from the Acme log.

    .EXAMPLE
        Get-MHLog -LogType "Postfix" -Raw

        Get records from the Postfix log in raw format as returned by the REST API. By default the last 20 records are returned.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Log.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Specify the type of log to return.")]
        [ValidateSet("Acme", "Api", "Autodiscover", "Dovecot", "Netfilter", "Postfix", "RateLimited", "Rspamd-History", "Sogo", "Watchdog")]
        [System.String]
        $Logtype,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The number of logs records to return. This always returns the latest (newest) log records.")]
        [ValidateRange(1, 9223372036854775807)]
        [System.Decimal]
        $Count = 20,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Sort log output in descending order by date.")]
        [System.Management.Automation.SwitchParameter]
        $SortDesending,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/logs/"

    # Build full Uri.
    $RequestUriPath = $UriPath + "$($Logtype.ToLower())/$count"
    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        $i = 0
        $FormatColors = @{
            RedWhite = "`e[41m{0}`e[0m" # Red background, white foreground
            DarkRed  = "`e[91m{0}`e[0m"
            Red      = "`e[31m{0}`e[0m"
            Yellow   = "`e[33m{0}`e[0m"
            Blue     = "`e[34m{0}`e[0m"
            Cyan     = "`e[36m{0}`e[0m"
            Green    = "`e[32m{0}`e[0m"
            Magenta  = "`e[35m{0}`e[0m"
        }
        switch ($Logtype) {
            "Acme" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Api" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Uri      = $Item.uri
                        Method   = $Item.method
                        Remote   = $Item.remote
                        Data     = $Item.data
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Autodiscover" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID        = $i++
                        Logtype   = $LogType
                        DateTime  = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        UserAgent = $Item.ua
                        Username  = $Item.user
                        IP        = $Item.ip
                        Service   = $Item.service
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Dovecot" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    switch ($Item.priority) {
                        "crit" {
                            $ColorFormat = $FormatColors.RedWhite
                            break
                        }
                        "err" {
                            $ColorFormat = $FormatColors.DarkRed
                            break
                        }
                        "warning" {
                            $ColorFormat = $FormatColors.Yellow
                            break
                        }
                        "info" {
                            $ColorFormat = $FormatColors.Green
                            break
                        }
                        "debug" {
                            $ColorFormat = $FormatColors.Magenta
                            break
                        }
                        default {
                            $ColorFormat = "{0}"
                        }
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $ColorFormat -f $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Netfilter" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    switch ($Item.priority) {
                        "crit" {
                            $ColorFormat = $FormatColors.RedWhite
                            break
                        }
                        "error" {
                            $ColorFormat = $FormatColors.DarkRed
                            break
                        }
                        "warn" {
                            $ColorFormat = $FormatColors.Yellow
                            break
                        }
                        "info" {
                            $ColorFormat = $FormatColors.Green
                            break
                        }
                        "debug" {
                            
                            $ColorFormat = $FormatColors.Magenta
                            break
                        }
                        default {
                            # Default color
                            $ColorFormat = "{0}"
                        }
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Priority = $ColorFormat -f $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Postfix" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    switch ($Item.priority) {
                        "crit" {
                            $ColorFormat = $FormatColors.RedWhite
                            break
                        }
                        "error" {
                            $ColorFormat = $FormatColors.DarkRed
                            break
                        }
                        "warn" {
                            $ColorFormat = $FormatColors.Yellow
                            break
                        }
                        "info" {
                            $ColorFormat = $FormatColors.Green
                            break
                        }
                        "debug" {
                            $ColorFormat = $FormatColors.Magenta
                            break
                        }
                        default {
                            # Default color
                            $ColorFormat = "{0}"
                        }
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $ColorFormat -f $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "RateLimited" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID            = $i++
                        Logtype       = $LogType
                        DateTime      = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        From          = $Item.from
                        HeaderFrom    = $Item.header_from
                        HeaderSubject = $Item.header_subject
                        IP            = $Item.ip
                        MessageId     = $Item.message_id
                        Qid           = $Item.qid
                        Rcpt          = $Item.rcpt
                        RlHash        = $Item.rl_hash
                        RlInfo        = $Item.rl_info
                        RlName        = $Item.rl_name
                        User          = $Item.user

                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Rspamd-History" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID            = $i++
                        Logtype       = $LogType
                        DateTime      = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Size          = $Item.size
                        SenderSmtp    = $Item.sender_smtp
                        RcptSmtp      = $Item.rcpt_smtp
                        RcptMime      = $Item.rcpt_mime
                        Subject       = $Item.subject
                        IsSkipped     = $Item.is_skipped
                        RequiredScore = $Item.required_score
                        TimeReal      = $Item.time_real
                        MessageId     = $Item."message-id"
                        IP            = $Item.ip
                        Thresholds    = $Item.thresholds
                        Action        = $Item.action
                        Symbols       = $Item.symbols
                        User          = $Item.user
                        Score         = $Item.score
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Sogo" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    switch ($Item.priority) {
                        "crit" {
                            $ColorFormat = $FormatColors.RedWhite
                            break
                        }
                        "err" {
                            $ColorFormat = $FormatColors.DarkRed
                            break
                        }
                        "warning" {
                            $ColorFormat = $FormatColors.Yellow
                            break
                        }
                        "info" {
                            $ColorFormat = $FormatColors.Green
                            break
                        }
                        "notice" {
                            $ColorFormat = $FormatColors.Cyan
                            break
                        }
                        "debug" {
                            $ColorFormat = $FormatColors.Magenta
                            break
                        }
                        default {
                            # Default color
                            $ColorFormat = "{0}"
                        }
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $ColorFormat -f $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            "Watchdog" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID       = $i++
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Service  = $Item.service
                        Level    = $Item.lvl
                        hpnow    = $Item.hpnow
                        hptotal  = $Item.hptotal
                        hpdiff   = $Item.hpdiff
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult | Sort-Object -Property ID -Descending:$(-not $SortDesending.IsPresent)
            }
            default {
                # Return the result in raw format.
                Write-MailcowHelperLog -Message "Returning raw result for unknown log type."
                $Result
            }
        }
    }
}