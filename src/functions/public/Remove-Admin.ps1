function Remove-Admin {
    <#
    .SYNOPSIS
        Removes an admin user account.

    .DESCRIPTION
        Removes an admin user account.

    .PARAMETER Identity
        The login name for the new admin user account.

    .EXAMPLE
        Remove-MHAdmin -Identity "cowboy"

        This will remove the admin user account named "cowboy" after confirming to do so.

    .EXAMPLE
        Remove-MHAdmin -Identity "cowboy" -Confirm:$false

        This will remove the admin user account named "cowboy" without confirming.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Identity of the admin user account to remove.")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $Identity

            if ($PSCmdlet.ShouldProcess("mailcow admin [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailcow admin [$IdentityItem]." -Level Warning

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
}
