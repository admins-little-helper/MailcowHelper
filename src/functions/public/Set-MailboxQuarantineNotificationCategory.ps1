function Set-MailboxQuarantineNotificationCategory {
    <#
    .SYNOPSIS
        Updates the quarantine notfication interval for one or more mailboxes.

    .DESCRIPTION
        Updates the quarantine notfication interval for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for want to set the quarantine notification category.

    .PARAMETER QuaranantineCategory
        The notificatoin category.
        Valid values are Rejected, Junk folder, All categories.

    .EXAMPLE
        Set-MHMailboxQuarantineNotificationCategory -Identity "user123@example.com" QuaranantineCategory "All categories"

        Set the notification category to "All categories" for the mailbox of the user "user123@example.com".

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
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for want to set the quarantine notification category.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuaranantineCategory
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/quarantine_category"
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
                quarantine_category = switch ($QuaranantineCategory) {
                    "Rejected" {
                        "reject"
                        break
                    }
                    "Junk folder" {
                        "add_header"
                        break
                    }
                    default {
                        # "All categories"
                        "all"
                    }
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox quarantine notification category for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating quarantine notification category for [$LogIdString]." -Level Information
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
