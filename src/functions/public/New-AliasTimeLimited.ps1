function New-AliasTimeLimited {
    <#
    .SYNOPSIS
        Adds a time-limited alias (spamalias) to a mailbox.

    .DESCRIPTION
        Adds a time-limited alias (spamalias) to a mailbox.

    .PARAMETER Identity
        The mail address of the mailbox for which to create a time-limited alias.

    .PARAMETER ForAliasDomain
        The alias domain in which to create a new time-limited alias.
        This must be an alias domain that is valid for the specified user"s primary domain.

    .PARAMETER Description
        Description for the time-limited alias.
        The description can only be set during creation. It can not be updated afterwards (neither in the WebGui nor via the API).

    .PARAMETER Permanent
        If specified, the time-limit alias will be set to never expire.
        Otherwise any new time-limited alias will be set to expire in 1 year.
        You can use "Set-AliasTimeLimited" to change the the validity period afterwards.

    .PARAMETER ExpireIn
        Set a predefined time period. Allowed values are:
        1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

    .PARAMETER ExpireInHours
        Set a custom value as number of hours from now.
        The valid range is 1 to 105200, which is between 1 hour and about 12 years.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Permanent

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The new alias will not expire.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The alias will by default be valid for/expire in 1 year.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"
        $NewAliasAddress = (Get-MHAliasTimeLimited -Identity "mailbox@example.com" | Sort-Object -Property WhenCreated | Select-Object -Last 1).Address
        $NewAliasAddress | Set-MHAliasTimeLimited -ExpireIn 1Week

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The alias will by default be valid for/expire in 1 year.
        Then the newest alias address is stored in $NewAliasAddress" and the expiration is set to 1 week.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "ExpireIn", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to create a time-limited alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The alias domain in which to create a new time-limited alias.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String]
        $ForAliasDomain,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Description for the time-limited alias.")]
        [System.String]
        $Description,

        [Parameter(ParameterSetName = "Permanent", Position = 3, Mandatory = $false, HelpMessage = "If specified, the time-limited alias will not expire.")]
        [System.Management.Automation.SwitchParameter]
        $Permanent,

        [Parameter(ParameterSetName = "ExpireIn", Position = 3, Mandatory = $false, HelpMessage = "Set when the time-limited alias should expire by selecting from a list of timeframes.")]
        [ValidateSet("1Hour", "1Day", "1Week", "1Month", "1Year", "10Years")]
        [System.String]
        $ExpireIn = "1Year",

        [Parameter(ParameterSetName = "ExpireInHours", Position = 3, Mandatory = $false, HelpMessage = "Specify in how many hours the time-limited alias should exipre.")]
        [ValidateRange(1, 105200)]
        [System.Int32]
        $ExpireInHours
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/time_limited_alias"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                username = $IdentityItem.Address
                # Set the domain either to the specified alias domain or to the mailbox domain.
                domain   = if (-not [System.String]::IsNullOrEmpty($ForAliasDomain)) { $ForAliasDomain } else { $IdentityItem.Host }

                # Theoretically it would be possible to specifiy a validity argument in the API call.
                # The validity value is the number of hours from now in a range of 1 to 87600. The API function accepts the value
                # See "data/web/inc/functions.mailbox.inc.php".
                # The problem is, that the API overwrites any valid results with the value 8760 (hours) which is 365 days, so one year.
                # If "validity" is missing, then also 1 year is the default. Any invalid or out-of-range values will lead to an error.
                # Finally all time limited aliases are created by default for 1 year
                # However, it is possible to change the validity using the "Set-AliasTimeLimited" function for an existing alias.
                # Or the user can change in the SOGo WebGUI.
                # This is as of 2026-JAN-18
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                # The description can only be set during creation. It can not be updated afterwards (neither in the WebGui nor via the API).
                $Body.description = $Description
            }
            if ($PSBoundParameters.ContainsKey("Permanent")) {
                $Body.permanent = if ($Permanent.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("time-limited alias to mailbox [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding time-limited alias to mailbox [$($IdentityItem.Address)]." -Level Information

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
}
