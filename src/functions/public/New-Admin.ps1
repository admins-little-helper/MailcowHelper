function New-Admin {
    <#
    .SYNOPSIS
        Add a new admin user account on the mailcow server.

    .DESCRIPTION
        Add a new admin user account on the mailcow server.

    .PARAMETER Username
        The login name for the new admin user account.

    .PARAMETER Password
        The password for the new admin user account as secure string.

    .PARAMETER Enable
        Enable or disable the new admin user account. By default all new admin accounts are created in enabled state.
        Use "-Enable:$false" to create an account in disabled state.

    .EXAMPLE
        New-MHAdmin -Username "cowboy"

        This will create a new admin user account named "cowboy". The password is mandatory and requested to be typed in as secure string.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Username of the admin user account to create.")]
        [Alias("Identity")]
        [System.String[]]
        $Username,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The password for the new admin user account as secure string.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the new admin user account. ")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/admin"
    }

    process {
        foreach ($UsernameItem in $Username) {
            # Prepare the request body.
            $Body = @{
                username  = $UsernameItem
                password  = $Password | ConvertFrom-SecureString -AsPlainText
                password2 = $Password | ConvertFrom-SecureString -AsPlainText
                active    = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("admin user account [$UsernameItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding admin user account [$UsernameItem]." -Level Information

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
