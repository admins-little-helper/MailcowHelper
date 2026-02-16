function Remove-Mailbox {
    <#
    .SYNOPSIS
        Delete one or more mailboxes.

    .DESCRIPTION
        Delete one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox to be deleted.

    .EXAMPLE
        Remove-MHMailbox -Identity "user123@example.com"

        Deletes the mailbox with address "user123@example.com".

    .EXAMPLE
        Remove-MHMailbox -Identity "user123@example.com", "user456@example.com" -Confirm:$false

        Deletes the mailboxes with address "user123@example.com" and "user456@example.com" without extra confirmation.

    .EXAMPLE
        (Get-MHMailbox -Tag "MarkedForDeletion").Username | Remove-MHMailbox -Confirm:$false

        Returns all mailboxes with the tag "MarkedForDeletion" and pipes it to the Remove-MHMailbox function to delete it without further confirmation.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to be deleted.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/mailbox"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("mailbox [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailbox [$($IdentityItem.Address)]." -Level Warning

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
