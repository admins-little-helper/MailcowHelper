function Remove-TlsPolicyMap {
    <#
    .SYNOPSIS
        Removes one or more TLS policy map override maps.

    .DESCRIPTION
        Removes one or more TLS policy map override maps.

     .PARAMETER Id
        The TLS policy map ID to delete.

    .EXAMPLE
        Remove-MHTlsPolicyMap -Id 12

        Delete TLS policy map with id 12.

    .EXAMPLE
        Get-MHTlsPolicyMap -Identity 17 | Remove-MHTlsPolicyMap

        Delete TLS policy map with id 12.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The TLS policy map ID to delete.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/tls-policy-map"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("TLS policy map [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting TLS policy map [$($Id -join ",")]." -Level Warning

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
