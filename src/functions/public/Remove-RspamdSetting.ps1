function Remove-RspamdSetting {
    <#
    .SYNOPSIS
        Removes one or more Rspamd rules.

    .DESCRIPTION
        Removes one or more Rspamd rules.

    .PARAMETER Id
        The ID number of a specific Rspamd rule.

    .EXAMPLE
        Remove-MHRspamdSetting -Id 1

        Returns rule with id 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific Rspamd rule.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/rsetting"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("Rspamd rule [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting Rspamd rule [$($Id -join ",")]." -Level Warning

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
}
