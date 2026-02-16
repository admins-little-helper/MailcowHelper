function Get-Queue {
    <#
    .SYNOPSIS
        Get the current mail queue and everything it contains.

    .DESCRIPTION
        Get the current mail queue and everything it contains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHQueue

        Get the current mail queue and everything it contains.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/mailq/all"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                QueueId     = $Item.queue_id
                QueueName   = $Item.queue_name
                Recipients  = $Item.recipients
                Sender      = $Item.sender
                MessageSize = $Item.message_size
                ArrivalTime = if ($Item.arrival_time) { (Get-Date -Date $Item.arrival_time) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHQueue")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}