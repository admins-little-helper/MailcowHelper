function Set-DomainAdmin {
    <#
    .SYNOPSIS
        Updates one or more domain admin user accounts.

    .DESCRIPTION
        Updates one or more domain admin user accounts.

    .PARAMETER Identity
        The username of the domain admin account to update.

    .PARAMETER Domain
        Set the domain for which the domain user account should become an admin.

    .PARAMETER NewUsername
        Set the new username for the domain admin user account.

    .PARAMETER Password
        Set the password for the domain admin user account.

    .PARAMETER Enable
        Enable or disable the domain admin user account.

    .EXAMPLE
        Set-MHDomainAdmin -Identity "AdminForExampleDotCom" -Domain "sub.example.com"

        Make the existing domain admin usre "AdminForExampleDotCom" an admin of the domain "sub.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin account to update.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("Username")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Set the domain for which the domain user account should become an admin.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Set the new username for the domain admin user account.")]
        [System.String]
        $NewUsername,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Set the password for the domain admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the domain admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain-admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Domain")) {
                $Body.attr.domains = $Domain
            }
            if ($PSBoundParameters.ContainsKey("NewUsername")) {
                $Body.attr.username_new = $NewUsername.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Password")) {
                $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
                $Body.attr.password2 = $Password | ConvertFrom-SecureString -AsPlainText
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("domain admin [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain admin [$IdentityItem]." -Level Information

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
