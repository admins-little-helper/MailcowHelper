function Remove-MailboxTag {
    <#
    .SYNOPSIS
        Remove one or more tags from one or more mailboxes.

    .DESCRIPTION
        Remove one or more tags from one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox from where to remove a tag.

    .PARAMETER Tag
        The tag to remove.

    .EXAMPLE
        Remove-MHMailboxTag -Identity "user123@example.com" -Tag "MyTag"

        Removes the tag "MyTag" from mailbox "user123@example.com".

    .EXAMPLE
        Get-MHMailbox -Tag "MyTag" | Remove-MHMailboxTag -Tag "MyTag"

        Gets all mailboxes tagged with "MyTag" and removes that tag.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTag.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox from where to remove a tag.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The tag to remove.")]
        [System.String[]]
        $Tag
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/mailbox/tag/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode("$($IdentityItem.Address.ToLower())")

            # Prepare the request body.
            $Body = $Tag

            if ($PSCmdlet.ShouldProcess("mailbox tag [$($Tag -join ',')].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailbox tag [$($Tag -join ',')] from mailbox [$($IdentityItem.Address)]." -Level Warning

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
}
