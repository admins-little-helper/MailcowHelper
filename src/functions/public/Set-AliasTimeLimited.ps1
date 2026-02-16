function Set-AliasTimeLimited {
    <#
    .SYNOPSIS
        Updates one or more time-limited aliases (spamalias).

    .DESCRIPTION
        Updates one or more time-limited aliases (spamalias).

    .PARAMETER Identity
        The time-limited alias mail address to be updated.

    .PARAMETER Permanent
        If specified, the time-limit alias will be set to never expire.

    .PARAMETER ExpireIn
        Set a predefined time period. Allowed values are:
        1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

    .PARAMETER ExpireInHours
        Set a custom value as number of hours from now.
        The valid range is 1 to 105200, which is between 1 hour and about 12 years.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -Permanent

        Set the alias "alias@example.com" to not expire.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireIn "1Week"

        Set the alias "alias@example.com" to expire in 1 week from now.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireInHours 48

        Set the alias "alias@example.com" to expire in 48 hours from now.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "ExpireIn", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The time-limited alias mail address to be updated.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "Permanent", Position = 1, Mandatory = $true, HelpMessage = "If specified, the time-limited alias will not expire.")]
        [System.Management.Automation.SwitchParameter]
        $Permanent,

        [Parameter(ParameterSetName = "ExpireIn", Position = 1, Mandatory = $true, HelpMessage = "Set when the time-limited alias should expire by selecting from a list of timeframes.")]
        [ValidateSet("1Hour", "1Day", "1Week", "1Month", "1Year", "10Years")]
        [System.String]
        $ExpireIn,

        [Parameter(ParameterSetName = "ExpireInHours", Position = 1, Mandatory = $true, HelpMessage = "Specify in how many hours the time-limited alias should exipre.")]
        [ValidateRange(1, 105200)]
        [System.Int32]
        $ExpireInHours
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/time_limited_alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.Address
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Permanent")) {
                $Body.attr.permanent = if ($Permanent.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("ExpireIn")) {
                # Calculate the ExpireInHours value based on the selected input.
                switch ($ExpireIn) {
                    "1Hour" {
                        $ExpireInHours = 1
                        break
                    }
                    "1Day" {
                        $ExpireInHours = 1 * 24
                        break
                    }
                    "1Week" {
                        $ExpireInHours = 1 * 24 * 7
                        break
                    }
                    "1Month" {
                        # Either simply calculate 1 month of 30 days.
                        # $ExpireInHours = 1 * 24 * 30
                        # Or use the Get-Date function and add 1 month, which considers the real number of days of a month.
                        $ExpireInHours = ((Get-Date).AddYears(10) - (Get-Date)).TotalHours
                        break
                    }
                    "1Year" {
                        # Either simply calculate 1 years of 365 days (ignoring leap years).
                        # $ExpireInHours = 1 * 24 * 365
                        # Or use the Get-Date function and add 1 year, which respects leap years.
                        $ExpireInHours = ((Get-Date).AddYears(1) - (Get-Date)).TotalHours
                        break
                    }
                    "10Years" {
                        # Either simply calculate 10 years of 365 days (ignoring leap years).
                        # $ExpireInHours = 1 * 24 * 365 * 10
                        # Or use the Get-Date function and add 10 years, which respects leap years.
                        $ExpireInHours = ((Get-Date).AddYears(10) - (Get-Date)).TotalHours
                        break
                    }
                    default {
                        # Should never reach this point.
                        break
                    }
                }
                $Body.attr.validity = $ExpireInHours
            }
            if ($PSBoundParameters.ContainsKey("ExpireInHours")) {
                # Set the number of hours as specified.
                $Body.attr.validity = $ExpireInHours
            }

            if ($PSCmdlet.ShouldProcess("time-limited alias [$($IdentityItem.Address)].", "Update")) {
                Write-MailcowHelperLog -Message "Updating time-limited alias [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}
