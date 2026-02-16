function Set-Admin {
    <#
    .SYNOPSIS
        Updates an admin user account.

    .DESCRIPTION
        Updates an admin user account.

    .PARAMETER Username
        The login name for the new admin user account.

    .PARAMETER Password
        The password for the new admin user account as secure string.

    .PARAMETER Enable
        Enable or disable the new admin user account. By default all new admin accounts are created in enabled state.
        Use "-Enable:$false" to create an account in disabled state.

    .EXAMPLE
        Set-MHAdmin -Username "cowboy"

        This will create a new admin user account named "cowboy". The password is mandatory and requested to be typed in as secure string.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Username of the admin user account to update.")]
        [Alias("Identity")]
        [System.String]
        $Username,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The new password for the admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/admin"
    }

    process {
        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = $Identity
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
            $Body.attr.password2 = $Password | ConvertFrom-SecureString -AsPlainText
        }

        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailcow admin user account [$Identity].", "Update")) {
            Write-MailcowHelperLog -Message "Updating admin user account [$Identity]." -Level Information
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
