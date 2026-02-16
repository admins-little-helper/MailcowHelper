function Test-MailboxPushover {
    <#
    .SYNOPSIS
        Test Pushover notification settings for one or more Mailcow mailboxes.

    .DESCRIPTION
        Test Pushover notification settings for one or more Mailcow mailboxes.

    .PARAMETER Identity
        The mailbox (email address) for which Pushover settings should be verified.

    .EXAMPLE
        Test-MHMailboxPushover -Identity "user@example.com"

        Verifies Pushover notification settings for the specified mailbox.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Test-MailboxPushover.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to test PushOver settings.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/pushover-test"
    }

    process {
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
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        Write-MailcowHelperLog -Message "Test pushover settings for mailbox [$LogIdString]."

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
