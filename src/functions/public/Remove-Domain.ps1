function Remove-Domain {
    <#
    .SYNOPSIS
        Deletes one or more domains from mailcow server.

    .DESCRIPTION
        Deletes one or more domains from mailcow server.

    .PARAMETER Identity
        The domain name to delete.

    .EXAMPLE
        Remove-MHDomain -Identity "example.com"

        Deletes domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to delete.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $Identity

            if ($PSCmdlet.ShouldProcess("domain [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain [$IdentityItem]." -Level Warning
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
