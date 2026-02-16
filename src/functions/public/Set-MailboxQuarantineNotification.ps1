function Set-MailboxQuarantineNotification {
    <#
    .SYNOPSIS
        Updates the quarantine notfication interval for one or more mailboxes.

    .DESCRIPTION
        Updates the quarantine notfication interval for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the quarantine notification interval.

    .PARAMETER QuaranantineNotification
        The notificatoin interval.
        Valid values are Never, Hourly, Daily, Weekly.

    .EXAMPLE
        Set-MHMailboxQuarantineNotification -Identity "user123@example.com" -QuaranantineNotification "Daily"

        Set the notification period to "Daily" for the mailbox of the user "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the quarantine notification interval.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuaranantineNotification
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/quarantine_notification"
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
                quarantine_notification = $QuaranantineNotification.ToLower()
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox quarantine notification interval for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "Updating quarantine notification interval for [$LogIdString]." -Level Information

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
