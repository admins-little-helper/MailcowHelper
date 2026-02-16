function Get-Quarantine {
    <#
    .SYNOPSIS
        Get all mails that are currently in quarantine.

    .DESCRIPTION
        Get all mails that are currently in quarantine.

    .PARAMETER Id
        The id of the mail in the quarantine for which to get information.
        If omitted, all items in the quarantine are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHQuarantine -Id 17

        Returns information about the mail item with id 17.

    .EXAMPLE
        Get-MHQuarantine

        Returns information about all mails in the quarantine.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Quarantine.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The id of the mail in the quarantine for which to get information.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/quarantine/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Id          = $Item.id
                        QId         = $Item.qid
                        Notified    = [System.Boolean][System.Int32]$Item.notified
                        Recipient   = $Item.rcpt
                        Score       = $Item.score
                        Sender      = $Item.sender
                        Subject     = $Item.subject
                        VirusFlag   = [System.Boolean][System.Int32]$Item.virus_flag
                        WhenCreated = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHQuarantine")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}