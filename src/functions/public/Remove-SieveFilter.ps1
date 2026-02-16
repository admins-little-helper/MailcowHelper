function Remove-SieveFilter {
    <#
    .SYNOPSIS
        Removes one or more admin defined Sieve filter scripts.

    .DESCRIPTION
        Removes one or more admin defined Sieve filter scripts.

    .PARAMETER Id
        The id of the filter script.

    .EXAMPLE
        Remove-MHSieveFilter -Id 14

        Removes filter script with id 14.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the filter script.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/filter/"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("Sieve filter script [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting Sieve filter script [$($Id -join ",")]." -Level Warning

            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $UriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}
