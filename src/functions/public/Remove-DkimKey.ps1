function Remove-DkimKey {
    <#
    .SYNOPSIS
        Deletes a DKIM key for one or more domains.

    .DESCRIPTION
        Deletes a DKIM key for one or more domains.

    .PARAMETER Domain
        The name of the domain for which to delete the DKIM key.

    .EXAMPLE
        Remove-MHDkimKey -Domain "example.com"

        Deletes the DKIM key for the domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to delete the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/dkim"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = $Domain

            if ($PSCmdlet.ShouldProcess("DKIM key for domain [$DomainItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting DKIM key for domain [$DomainItem]." -Level Warning

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
