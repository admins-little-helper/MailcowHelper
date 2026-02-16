function Get-ForwardingHost {
    <#
    .SYNOPSIS
        Returns the forwarding hosts configured in mailcow.

    .DESCRIPTION
        Returns the forwarding hosts configured in mailcow.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHForwardingHost

        Returns the forwarding hosts configured in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/fwdhost/all"

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
                Host     = $Item.host
                Source   = $Item.source
                KeepSpam = $Item.keep_spam
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHForwardingHost")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}