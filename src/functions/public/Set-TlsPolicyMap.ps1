function Set-TlsPolicyMap {
    <#
    .SYNOPSIS
        Updates one or more TLS policy map overrides.

    .DESCRIPTION
        Updates one or more TLS policy map overrides.

    .PARAMETER Id
        The TLS policy map ID to update.

    .PARAMETER Policy
        TLS Policy to use. Valid options are:
        None, May, Encrypt, Dane, Dane-Only, Fingerprint, Verify, Secure

    .PARAMETER Parameter
        Specify additional parameters.
        Example: "protocols=!SSLv2 ciphers=medium exclude=3DES"

    .PARAMETER Enable
        Enable or disable the TLS policy map override.

    .EXAMPLE
        Set-MHTlsPolicyMap -Id 12 -Policy Encrypt

        Changes the TLS policy type to "Encrypt" for the policy with ID 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The TLS policy map ID to update.")]
        [System.Int32[]]
        $Id,

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
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Policy")) {
            $Body.attr.policy = $Policy.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Parameter")) {
            $Body.attr.policy = $Parameter.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("TLS policy map override id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating TLS policy map override id [$($Id -join ",")]." -Level Information

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