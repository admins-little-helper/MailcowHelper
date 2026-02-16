function New-DomainAdmin {
    <#
    .SYNOPSIS
        Add a domain admin user account.

    .DESCRIPTION
        Add a domain admin user account.

    .PARAMETER Domain
        Specify one or more domains for which the domain admin gets permission.

    .PARAMETER Username
        Set the username for the domain admin user account.

    .PARAMETER Password
        Set the password for the domain admin user account.

    .PARAMETER Enable
        Enable or disable the domain admin user account.

    .EXAMPLE
        New-MHDomainAdmin -Domain "example.com" -Username "AdminForExampleDotCom"

        This will create a new domain admin user account named "AdminForExampleDotCom" for the domain "example.com".
        The command will promp to enter a password.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Set the domain for which the domain user account should become an admin.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Set the username for the domain admin user account.")]
        [System.String]
        $Username,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Set the password for the domain admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the domain admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain-admin"
    }

    process {
        # Prepare the request body.
        $Body = @{
            domains   = $Domain
            username  = $Username
            password  = $Password | ConvertFrom-SecureString -AsPlainText
            password2 = $Password | ConvertFrom-SecureString -AsPlainText
            active    = "1"
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("domain admin user account [$Username].", "Add")) {
            Write-MailcowHelperLog -Message "Adding domain admin user account [$Username]." -Level Information

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
