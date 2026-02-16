function Remove-DomainAdmin {
    <#
    .SYNOPSIS
        Deletes one or more domain admin user accounts.

    .DESCRIPTION
        Deletes one or more domain admin user accounts.

    .PARAMETER Identity
        The username of the domain admin user account to be deleted.

    .EXAMPLE
        Remove-MHDomainAdmin -Identity "ExampDaAdmin"

        Deletes the user account "ExampleDaAdmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin user account to be deleted.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("Username")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain-admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem

            if ($PSCmdlet.ShouldProcess("domain admin [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain admin [$IdentityItem]." -Level Warning

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
