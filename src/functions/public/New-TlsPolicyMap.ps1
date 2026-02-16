function New-TlsPolicyMap {
    <#
    .SYNOPSIS
        Create a new TLS policy map override.

    .DESCRIPTION
        Create a new TLS policy map override.

    .PARAMETER Domain
        The destination domain name.

    .PARAMETER Policy
        Policy to use. Valid options are:
        None, May, Encrypt, Dane, Dane-Only, Fingerprint, Verify, Secure

    .PARAMETER Parameter
        Specify additional parameters.
        Example: "protocols=!SSLv2 ciphers=medium exclude=3DES"

    .PARAMETER Enable
        Enable or disable the TLS policy map override.

    .EXAMPLE
        New-MHTlsPolicyMap -Destination "example.com" -Policy Encrypt

        Creates a new TLS policy map override for the destination domain "exmaple.com" using the "Encrypt" policy.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The destination domain name.")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Policy to use.")]
        [ValidateSet("None", "May", "Encrypt", "Dane", "Dane-Only", "Fingerprint", "Verify", "Secure")]
        [System.String]
        $Policy = "Encrypt",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Specify additional parameters.")]
        [System.String]
        $Parameter,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the TLS policy map override.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/tls-policy-map"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = @{
                dest       = $DomainItem.Trim().ToLower()
                policy     = $Policy.Trim().ToLower()
                parameters = $Parameter.ToLower()
                active     = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("TLS policy map override for [$($DomainItem.Trim())].", "Add")) {
                Write-MailcowHelperLog -Message "Adding TLS policy map override for [$($DomainItem.Trim())]." -Level Information

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