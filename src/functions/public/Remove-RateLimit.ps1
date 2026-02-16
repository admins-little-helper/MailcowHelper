function Remove-RateLimit {
    <#
    .SYNOPSIS
        Remove the rate limit for one or more mailboxs or domains.

    .DESCRIPTION
        Remove the rate limit for one or more mailboxs or domains.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to remove the rate-limit setting.

    .PARAMETER Domain
        The name of the domain for which to remove the rate-limit setting.

    .EXAMPLE
        Remove-MHRateLimit -Mailbox "user123@example.com"

        Removes the rate limit for mailbox of user "user123@example.com".

    .EXAMPLE
        Remove-MHRateLimit -Domain "example.com"

        Removes the rate limit for domain "example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RateLimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to remove the rate-limit setting.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to remove the rate-limit setting.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain
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
                    rl_value = "0"
                    # It does not really matter what time frame is specified, because rl_value = 0 disables it anyway, but the option is required in the API call.
                    rl_frame = "h"
                }
            }

            if ($PSCmdlet.ShouldProcess("rate limit for mailbox or domain [$MailboxOrDomain]", "Delete")) {
                Write-MailcowHelperLog -Message "Delete rate limit for mailbox or domain [$MailboxOrDomain]." -Level Information

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
