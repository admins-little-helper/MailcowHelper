function Remove-MHResource {
    <#
    .SYNOPSIS
        Remove one or more resource accounts.

    .DESCRIPTION
        Remove one or more resource accounts.

    .PARAMETER Identity
        The mail address of the resource to be deleted.

    .EXAMPLE
        Remove-MHResource -Identity "resource123@example.com"

        Removes the resource with mail address "resource123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the resource to be deleted.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/resource"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("resource [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting resource [$($IdentityItem.Address)]." -Level Warning

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
}
