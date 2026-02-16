function Remove-AppPassword {
    <#
    .SYNOPSIS
        Deletes one or more appliation-specific passwords.

    .DESCRIPTION
        Deletes one or more appliation-specific passwords.

    .PARAMETER Id
        The app password id.

    .EXAMPLE
        Remove-MHAppPassword -Identity 17

        Deletes app password with ID 17.

    .EXAMPLE
        Get-AppPassword -Identity "user1@example.com" | Remove-MHAppPassword

        Deletes all app passwords configured for the mailbox of "user1@example.com".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The app password id.")]
        [Alias("AppPasswordId")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/app-passwd"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("app password id [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting app password id [$($Id -join ",")].." -Level Warning

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
