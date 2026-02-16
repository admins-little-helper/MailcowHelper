function Set-RateLimit {
    <#
    .SYNOPSIS
        Updates the rate limit for one or more mailboxes or domains.

    .DESCRIPTION
        Updates the rate limit for one or more mailboxes or domains.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to set the rate-limit setting.

    .PARAMETER Domain
        The name of the domain for which to set the rate-limit setting.

    .PARAMETER RateLimitValue
        The rate limite value.

    .PARAMETER RateLimitFrame
        The rate limit unit. Valid values are:
        Second, Minute, Hour, Day

    .EXAMPLE
        Set-MHRateLimit -Mailbox "user123@example.com" -RateLimitValue 10 -RateLimitFrame Minute

        Set the rate-limit for mailbox of user "user123@example.com" to 10 messages per minute.

    .EXAMPLE
        Set-MHRateLimit -Domain "example.com" -RateLimitValue 1000 -RateLimitFrame Hour

        Set the rate-limit for domain "example.com" to 1000 messages per hour.

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RateLimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the rate limit.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to set the rate limit.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter( Position = 1, Mandatory = $true, HelpMessage = "The rate limit value.")]
        # Default mailbox quota accepts max 8 Exabyte.
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue,

        [Parameter( Position = 2, Mandatory = $false, HelpMessage = "The rate limit unit")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour"
    )

    begin {
        # Prepare the base Uri path.
        switch ($PSCmdlet.ParameterSetName) {
            "Mailbox" {
                $UriPath = "edit/rl-mbox"
                $MailboxOrDomain = foreach ($MailboxItem in $Mailbox) { $MailboxItem.Address }
            }
            "Domain" {
                $UriPath = "edit/rl-domain"
                $MailboxOrDomain = $Domain
            }
            default {
                # Should not reach this point.
                throw "Invalid parameter set detected. Can not continue."
            }
        }
    }

    process {
        foreach ($MailboxOrDomainItem in $MailboxOrDomain) {
            # Prepare the request body.
            $Body = @{
                items = $MailboxOrDomainItem
                attr  = @{
                    rl_value = $RateLimitValue.ToString()
                    rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
                }
            }

            if ($PSCmdlet.ShouldProcess("rate limit", "Update")) {
                Write-MailcowHelperLog -Message "Updating rate limit for [$MailboxOrDomain]  to [$RateLimitValue/$RateLimitFrame]." -Level Information

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
