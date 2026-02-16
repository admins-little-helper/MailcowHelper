function Get-Status {
    <#
    .SYNOPSIS
        Returns status information for the specified area for a mailcow server.

    .DESCRIPTION
        Returns status information for the specified area for a mailcow server.
        Accepted values for status area are:
        Containers, Host, Version, Vmail

    .PARAMETER Status
        The area for which to get status information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHStatus -Status Containers

        Returns status for the mailcow containers.

    .EXAMPLE
        Get-MHStatus -Status Host

        Returns mailcow server host information.

    .EXAMPLE
        Get-MHStatus -Status Version

        Returns the mailcow server version.

    .EXAMPLE
        Get-MHStatus -Status Vmail

        Returns status for the mailcow vmail and the amount of used storage.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Status.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The area for which to get status information.")]
        [ValidateSet("Containers", "Host", "Version", "Vmail")]
        [System.String]
        $Status = "Version",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/status/"

    # Build full Uri.
    $RequestUriPath = $UriPath + $Status.ToLower()

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    switch ($Status) {
        "Containers" {
            # Filter result for valid output.
            $Result = $Result.PSObject.Properties | Where-Object { $_.MemberType -eq "NoteProperty" } | ForEach-Object { $_.Value } | Sort-Object -Property Container

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Type      = $Item.type
                        Container = $Item.container
                        State     = $Item.state
                        StartedAt = if ($Item.started_at) { (Get-Date -Date $Item.started_at) }
                        Image     = $Item.image
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }

            break
        }
        "Host" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $Uptime = New-TimeSpan -Seconds $Item.Uptime
                    $BootUptIme = (Get-Date).Add( - $($Uptime))

                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        CpuCores           = $Item.cpu.cores
                        CpuUsagePercent    = $Item.cpu.usage
                        MemoryTotalMB      = $Item.memory.total / 1MB
                        MemoryUsagePercent = $Item.memory.usage
                        MemorySwap         = $Item.memory.swap
                        UptimeSeconds      = $Uptime.TotalSeconds
                        UptimeInfo         = $("$($Uptime.Days)D $($Uptime.Hours)H $($Uptime.Minutes)M $($Uptime.Seconds)S")
                        BootUpTime         = $BootUptIme
                        SystemTime         = $Item.system_time
                        Architecture       = $Item.architecture
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }

            break
        }
        "Version" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        Version = $Item.version
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            break
        }
        "Vmail" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        Type        = $Item.type
                        Disk        = $Item.disk
                        Total       = $Item.total
                        Used        = $Item.used
                        UsedPercent = $Item.used_percent
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            break
        }

        default {
            # Should never reach this point.
            Write-MailcowHelperLog -Message "Error - unknown status type defined!" -Level Errors
        }
    }
}
