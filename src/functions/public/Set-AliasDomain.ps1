function Set-AliasDomain {
    <#
    .SYNOPSIS
        Updates one or more alias domains.

    .DESCRIPTION
        Updates one or more alias domains.

    .PARAMETER Identity
        The alias domain name.

    .PARAMETER TargetDomain
        The target domain for the  alias.

    .PARAMETER Enable
        Enable or disable the alias domain.

    .EXAMPLE
        Set-MHAliasDomain -Identity "alias.example.com" -TargetDomain "example.com"

        Sets the target domain to "example.com" for the existing alis domain "alias.example.com".

    .EXAMPLE
        Set-MHAliasDomain -Identity "alias.example.com" -Enable:$false

        Disables the alias domain "alias.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias domain name.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The target domain for the alias domain.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $TargetDomain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the alias domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.Trim().ToLower()
                attr  = @{
                    # Set the Alias domain name.
                    alias_domain  = $IdentityItem.Trim().ToLower()
                    # Set the target domain name for the alias domain.
                    target_domain = $TargetDomain.Trim().ToLower()
                }
            }
            if ($PSBoundParameters.ContainsKey("TargetDomain")) {
                # Set the rate limit unit, if it was specified.
                $Body.attr.target_domain = $TargetDomain.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating alias domain [$IdentityItem]." -Level Information
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
