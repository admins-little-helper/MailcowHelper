function New-DkimKey {
    <#
    .SYNOPSIS
        Adds a DKIM key for a domain.

    .DESCRIPTION
        Adds a DKIM key for a domain.

    .PARAMETER Domain
        The name of the domain for which to create a DKIM key.

    .PARAMETER DkimSelector
        The DKIM selector name.
        By defaults set to "dkim".

    .PARAMETER KeySize
        The keysize for the DKIM key.
        By defaults set to 2096.
        Allowed values are 1024, 2024, 4096, 8192.

    .EXAMPLE
        New-MHDkimKey -Domain "example.com" -DkimSelector "dkim2026" -KeySize 2048

        Adds a new DKIM key for domain "example.com" with DKIM selector name "dkim2026" and a keysize of 2048.

    .EXAMPLE
        (Get-Domain).DomainName | New-MHDkimKey

        Creates a new DKIM key for each mailcow domain using the default options.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to create a DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The DKIM selector name.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The keysize for the DKIM key.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $KeySize = 2096
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/dkim"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = @{
                domains       = $DomainItem
                dkim_selector = $DkimSelector
                key_size      = $KeySize
            }

            if ($PSCmdlet.ShouldProcess("admin DKIM key for domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding DKIM key for domain [$DomainItem]." -Level Information

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
