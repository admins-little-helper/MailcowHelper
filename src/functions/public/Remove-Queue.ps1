function Remove-Queue {
    <#
    .SYNOPSIS
        Delete the current mail queue. This will delete all mails in the queue.

    .DESCRIPTION
        Delete the current mail queue. This will delete all mails in the queue.

    .EXAMPLE
        Remove-MHQueue

        Delete the current mail queue. This will delete all mails in the queue.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param()

    # Prepare the base Uri path.
    $UriPath = "delete/mailq"

    # Prepare the request body.
    $Body = @{
        action = "super_delete"
    }

    if ($PSCmdlet.ShouldProcess("mail queue.", "Delete")) {
        Write-MailcowHelperLog -Message "Deleting all mails in the queue." -Level Warning
        # Execute the API call.
        $Result = Invoke-MailcowApiRequest -UriPath $UriPath -Method Post -Body $Body

        # Return the result.
        $Result
    }
}
