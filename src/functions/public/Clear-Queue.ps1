function Clear-Queue {
    <#
    .SYNOPSIS
        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .DESCRIPTION
        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .EXAMPLE
        Clear-MHQueue

        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Clear-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    # Prepare the base Uri path.
    $UriPath = "edit/mailq"

    # Prepare the request body.
    $Body = @{
        action = "flush"
    }

    if ($PSCmdlet.ShouldProcess("mailcow mail queue", "Flush")) {
        Write-MailcowHelperLog -Message "Flushing mailcow mail queue. Try to deliver all mails currently in the queue." -Level Information

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
