function Set-PasswordNotification {
    <#
    .SYNOPSIS
        Updates the password reset notification settings on the mailcow server.

    .DESCRIPTION
        Updates the password reset notification settings on the mailcow server.

    .PARAMETER FromAddress
        The sender address for password reset notification emails.

    .PARAMETER Subject
        The subject of the password reset notification email.

    .PARAMETER BodyText
        The body of the password reset notification email in plain text format.

    .PARAMETER MustContainLowerUpperCase
        The body of the password reset notification email in plain HTML format.

    .EXAMPLE
        Set-MHPasswordNotification -From "password-reset@example.com" -Subject "Password reset"

        Set the sender address and the subject for password reset notification emails in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-PasswordNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The sender address for password reset notification emails.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $FromAddress,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The subject of the password reset notification email.")]
        [System.String]
        $Subject,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The body of the password reset notification email in plain text format.")]
        [System.String]
        $BodyText,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The body of the password reset notification email in plain HTML format.")]
        [System.String]
        $BodyHtml
    )

    begin {
        $UriPath = "edit/reset-password-notification"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{}
        }
        if ($PSBoundParameters.ContainsKey("FromAddress")) {
            $Body.attr.from = $FromAddress.Address
        }
        if ($PSBoundParameters.ContainsKey("Subject")) {
            $Body.attr.subject = $Subject.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BodyText")) {
            $Body.attr.text = $BodyText
        }
        if ($PSBoundParameters.ContainsKey("BodyHtml")) {
            $Body.attr.html = $BodyHtml
        }

        if ($PSCmdlet.ShouldProcess("password reset notification", "update")) {
            Write-MailcowHelperLog -Message "Updating password reset notification." -Level Information

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
