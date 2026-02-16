function Set-MailboxSpamScore {
    <#
    .SYNOPSIS
        Updates the spam score for one or more mailboxes.

    .DESCRIPTION
        Updates the spam score for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the spam score.

    .PARAMETER SpamScoreLow
        The low spam score value.

    .PARAMETER SpamScoreHigh
        The high spam score value.

    .EXAMPLE
        Set-MHMailboxSpamScore -Identity "user123@example.com" -SpamScoreLow 7 -SpamScoreHigh 14

        Set the low and high spam score values for mailbox "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxSpamScore.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the spam score.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The low spam score value.")]
        [ValidateRange(0, 5000)]
        [System.Int32]
        $SpamScoreLow = 8,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The high spam score value.")]
        [ValidateRange(0, 5000)]
        [System.Int32]
        $SpamScoreHigh = 15
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/spam-score"

        if ($SpamScoreLow -gt $SpamScoreHigh) {
            Write-MailcowHelperLog -Message "Spam score low level can not be greater the spam score high level." -Level Warning
            break
        }
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
                spam_score = "$SpamScoreLow,$SpamScoreHigh"
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox spam score for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox spam score for [$LogIdString]." -Level Information
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
