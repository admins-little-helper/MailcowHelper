function Set-AppPassword {
    <#
    .SYNOPSIS
        Updates one or more users application-specific password configurations.

    .DESCRIPTION
        Updates one or more users application-specific password configurations.

        To update an app password configuration, the app password id and the mailbox address
        must be specified.

    .PARAMETER Id
        The app password id.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to update the app password.

    .PARAMETER Name
        A name for the app password.

    .PARAMETER Password
        The password to set.

    .PARAMETER Protocol
        The protocol(s) for which the app password can be used.
        One or more of the following values:
        IMAP, DAV, SMTP, EAS, POP3, Sieve

    .PARAMETER Enable
        Enable or disable the app password.

    .EXAMPLE
        Set-MHAppPassword -Identity 7 -Name "New name for app password" -Protcol "EAS"

        Change the name for app password with ID 7 to "New name for app passwrord" and change the protocol to allow only "EAS".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The app password id.")]
        [Alias("AppPasswordId")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The mail address of the mailbox for which to update the app password.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress]
        $Mailbox,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "A name for the app password.")]
        [Alias("AppName")]
        [System.String]
        $Name,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The password to set.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The protocol(s) for which the app password can be used.")]
        [ValidateSet("IMAP", "DAV", "SMTP", "EAS", "POP3", "Sieve")]
        [System.String[]]
        $Protocol,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the app password.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/app-passwd"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Identity")) {
            $Body.attr.username = $Identity.Address
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.app_passwd = $Password | ConvertFrom-SecureString -AsPlainText
            $Body.attr.app_passwd2 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Name")) {
            $Body.attr.app_name = $Name
        }
        if ($PSBoundParameters.ContainsKey("Protocol")) {
            $Body.attr.protocols = foreach ($ProtocolItem in $Protocol) { $($ProtocolItem.ToLower()) + "_access" }
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("app password id [$($Id -join ",")].", "update")) {
            Write-MailcowHelperLog -Message "Updating app password id [$($Id -join ",")]." -Level Information

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
