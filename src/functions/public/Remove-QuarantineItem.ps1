function Remove-QuarantineItem {
    <#
    .SYNOPSIS
        Remove one or more mail items from the quarantine.

    .DESCRIPTION
        Remove one or more mail items from the quarantine.

    .PARAMETER Id
        The id of the item in the quarantine to be deleted.

    .EXAMPLE
        Remove-MHQuarantineItem -Id 17

        Removes the mail item with id 17.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-QuarantineItem.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The id of the item in the quarantine to be deleted.")]
        [System.Int32[]]
        $Id
    )

    # Prepare the base Uri path.
    $UriPath = "delete/qitem"

    # Prepare the request body.
    $Body = foreach ($IdItem in $Id) { $IdItem.ToString() }

    if ($PSCmdlet.ShouldProcess("mail quarantine [$($Id -join ",")].", "Delete")) {
        Write-MailcowHelperLog -Message "Deleting item from quarantine [$($Id -join ",")]." -Level Warning

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
    }

    # Return the result.
    $Result
}
