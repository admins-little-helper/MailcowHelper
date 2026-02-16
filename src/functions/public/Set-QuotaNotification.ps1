function Set-QuotaNotification {
    <#
    .SYNOPSIS
        Updates the quota notification mail configuration.

    .DESCRIPTION
        Updates the quota notification mail configuration.

    .PARAMETER FromAddress
        The sender address for quota notification emails.

    .PARAMETER Subject
        The subject of the quota notification email.

    .PARAMETER MustContainLowerUpperCase
        The body of the quota notification email in plain HTML format.

    .EXAMPLE
        Set-MHQuotaNotification -From "password-reset@example.com" -Subject "quota warning"

        Set the sender address and the subject for quota notification emails in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-QuotaNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The sender address for quota notification emails.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $FromAddress,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The subject of the quota notification email.")]
        [System.String]
        $Subject,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The body of the quota notification email in plain HTML format.")]
        [System.String]
        $BodyHtml
    )

    begin {
        $UriPath = "edit/quota_notification"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{}
        }
        if ($PSBoundParameters.ContainsKey("FromAddress")) {
            $Body.attr.sender = $FromAddress.Address
        }
        if ($PSBoundParameters.ContainsKey("Subject")) {
            $Body.attr.subject = $Subject.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BodyHtml")) {
            $Body.attr.html_tmpl = $BodyHtml
        }

        if ($PSCmdlet.ShouldProcess("quota notification", "Update")) {
            Write-MailcowHelperLog -Message "Updating quota notification." -Level Information

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
