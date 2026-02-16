function Set-MailboxTaggedMailHandling {
    <#
    .SYNOPSIS
        Updates plus-tagged mail handling for one or more mailboxes.

    .DESCRIPTION
        Updates plus-tagged mail handling for one or more mailboxes.

        In subfolder: a new subfolder named after the tag will be created below INBOX ("INBOX/Newsletter").
        In subject: the tags name will be prepended to the mails subject, example: "[Newsletter] My News".
        Do nothing: no special handling for tagged mail.

        Example for a tagged email address: me+Newsletter@example.org

    .PARAMETER Identity
        The mail address of the mailbox for which to update plus-tagged mail handling.

    .PARAMETER Action
        Specify the action for tagged mail.
        Valid values are: Subject, Subfolder, Nothing

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subfolder

        This will move tagged mails to a subfolder named after the tag.

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subject

        This will prepand the the tags name to the subject of the mail.

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Nothing

        This will do nothing extra for plus-tagged mail. Mail gets delivered to the inbox.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTaggedMailHandling.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to update plus-tagged mail handling.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Specify the action for plus-tagged mails.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [Alias("TaggedMailAction", "DelimiterAction")]
        [System.String]
        $Action
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/delimiter_action"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                tagged_mail_handler = $Action.ToLower()
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox tagged mail action for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating tagged mail action for [$LogIdString]." -Level Information
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
