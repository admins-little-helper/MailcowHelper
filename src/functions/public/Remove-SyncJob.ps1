function Remove-SyncJob {
    <#
    .SYNOPSIS
        Remove one or more sync jobs from the mailcow server.

    .DESCRIPTION
        Remove one or more sync jobs from the mailcow server.

    .PARAMETER Id
        The ID number for the sync job to delete.

    .EXAMPLE
        Remove-MHSyncJob -Id 8

        Removes sync job with ID number 8.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number for the sync job to delete.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/syncjob"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = $IdItem

            if ($PSCmdlet.ShouldProcess("syncjob [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting syncjob [$IdItem]." -Level Warning

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
