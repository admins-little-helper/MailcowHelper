function Set-DomainFooter {
    <#
    .SYNOPSIS
        Update the footer of one or more domains.

    .DESCRIPTION
        Update the footer of one or more domains.

    .PARAMETER Identity
        The name of the domain for which to update the footer.

    .PARAMETER HtmlFooter
        Footer in HTML format.

    .PARAMETER PlainFooter
        Footer in plain text format.

    .PARAMETER ExcludeMailbox
        One or more m address(es) to be excluded from the domain wide footer.

    .PARAMETER SkipFooterForReplies
        Don't add footer on reply messages.

    .EXAMPLE
        Set-MHDomainFooter -Identity "example.com" -HtmlFooter (Get-Content -Path "C:\Temp\example-com-footer.html") -SkipFooterForReplies

        This will read the content of the html file "C:\Temp\example-com-footer.html" and set it as footer for the domain "example.com"
        The footer will not be added on reply messages.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainFooter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to update the footer.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Footer in HTML format.")]
        [System.String]
        $HtmlFooter,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Footer in plain text format.")]
        [System.String]
        $PlainFooter,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Mail addres to be excluded from the domain wide footer.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $ExcludeMailbox,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Don't add footer on reply messages.")]
        [System.Management.Automation.SwitchParameter]
        $SkipFooterForReplies
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/footer/"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            items = $Identity
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("HtmlFooter")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Setting HTML footer."
            $Body.attr.html = $HtmlFooter
        }
        if ($PSBoundParameters.ContainsKey("PlainFooter")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Setting PLAIN footer."
            $Body.attr.plain = $PlainFooter
        }
        if ($PSBoundParameters.ContainsKey("ExcludeMailbox")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Excluding mailbox(es)."
            $Body.attr.mbox_exclude = $ExcludeMailbox.Address
        }
        if ($PSBoundParameters.ContainsKey("SkipFooterForReplies")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Skipping footer for reply messages."
            $Body.attr.skip_replies = if ($SkipFooterForReplies.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("domain footer [$($Identity -join ", ")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating domain footer [$($Identity -join ", ")]." -Level Information

            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}
