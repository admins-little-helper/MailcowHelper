function New-AliasDomain {
    <#
    .SYNOPSIS
        Adds a new alias domain.

    .DESCRIPTION
        Adds a new alias domain.

    .PARAMETER Identity
        The new alias domain name.

    .PARAMETER TargetDomain
        The target domain for the new alias.

    .PARAMETER Enable
        Enable or disable the new alias domain.
        By default all new alias domains are created in enabled state.

    .EXAMPLE
        New-MHAliasDomain -Identity "alias.example.com" -TargetDomain "example.com"

        Adds an alias domain "alias.example.com" for domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The new alias domain name.")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The target domain for the new alias domain.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $TargetDomain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the new alias domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                # By default, activate the new alias domain.
                active        = 1
                # Set the Alias domain name.
                alias_domain  = $IdentityItem.Trim().ToLower()
                # Set the target domain name for the alias domain.
                target_domain = $TargetDomain.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "add")) {
                Write-MailcowHelperLog -Message "Adding alias domain [$IdentityItem]." -Level Information
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
