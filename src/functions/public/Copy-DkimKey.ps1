function Copy-DkimKey {
    <#
    .SYNOPSIS
        Copy a DKIM key from one domain to another.

    .DESCRIPTION
        Copy a DKIM key from one domain to another.

    .PARAMETER SourceDomain
        Domain name from where to copy the DKIM key.

    .PARAMETER TargetDomain
        The name of the domain for which to import the DKIM key.

    .EXAMPLE
        Copy-MHDkimKey -SourceDomain "source.example.com" -DestinationDomain "destination.example.com"

        Duplicates the DKIM key from domain "source.example.com" for the domain "destination.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Copy-DkimKey.md
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Domain name from where to copy the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $SourceDomain,

        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to import the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $TargetDomain
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/dkim_duplicate"
    }

    process {
        foreach ($TargetDomainItem in $TargetDomain) {
            # Prepare the request body.
            $Body = @{
                from_domain = $SourceDomain
                to_domain   = $TargetDomainItem
            }

            if ($PSCmdlet.ShouldProcess("mailcow DKIM key", "Copy item")) {
                Write-MailcowHelperLog -Message "[$SourceDomain] --> [$TargetDomainItem] Copying DKIM key." -Level Information

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
