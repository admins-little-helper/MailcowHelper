function New-AppPassword {
    <#
    .SYNOPSIS
        Add a new application-specific password for a mailbox user.

    .DESCRIPTION
        Add a new application-specific password for a mailbox user.

    .PARAMETER Identity
        The mail address of the mailbox for which to add an app password.

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
        New-MHAppPassword -Identity "user1@example.com" -Name "New name for app password" -Protcol "EAS"

        Add an application-specific password for "user1@example.com" that can be used for Active Sync connections.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to add an app password.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "A name for the app password.")]
        [Alias("AppName")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The password to set.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The protocol(s) for which the app password can be used.")]
        [ValidateSet("IMAP", "DAV", "SMTP", "EAS", "POP3", "Sieve")]
        [System.String[]]
        $Protocol,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the app password.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/app-passwd"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                username    = $IdentityItem.Address
                app_name    = $Name
                app_passwd  = $Password | ConvertFrom-SecureString -AsPlainText
                app_passwd2 = $Password | ConvertFrom-SecureString -AsPlainText
                active      = "1"
            }
            if ($PSBoundParameters.ContainsKey("Protocol")) {
                $Body.protocols = foreach ($ProtocolItem in $Protocol) { $($ProtocolItem.ToLower()) + "_access" }
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("app password for mailbox [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding app password for mailbox [$($IdentityItem.Address)]." -Level Information

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
