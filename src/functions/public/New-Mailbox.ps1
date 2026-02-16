function New-Mailbox {
    <#
    .SYNOPSIS
        Add one or more mailboxes.

    .DESCRIPTION
        Add one or more mailboxes.

    .PARAMETER Identity
        The mail address for the new mailbox.

    .PARAMETER Name
        The name of the new mailbox. If ommited the local part of the mail address is used.

    .PARAMETER AuthSource
        The authentcation source to use. Default is "mailcow".

    .PARAMETER Password
        The password for the new mailbox user.

    .PARAMETER ActiveState
        The mailbox state. Valid values are:
        Active = Mails to the mail address are accepted, the account is enabled, so login is possible.
        DisallowLogin = Mails to the mail address are accepted, the account is disabled, so login is denied.
        Inactive = Mails to the mail address are rejected, the account is disabled, so login is denied.

    .PARAMETER MailboxQuota
        The mailbox quota in MB.
        If ommitted, the domain default mailbox quota will be applied.

    .PARAMETER Tag
        Add a tag that can be used for filtering

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections for this mailbox.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections from this mailbox.

    .PARAMETER Template
        The mailbox template to use.

    .EXAMPLE
        New-MHMailbox -Identity "user123@example.com" -Template "MyCustomMailboxTemplate"

        Creates a new mailbox for "user123@example.com". The mailbox is configured based on settings from a template.

    .EXAMPLE
        New-MHMailbox -Identity "user456@example.com" -ActiveState DisallowLogin

        Creates a new mailbox for "user456@example.com". The mailbox is set to disallow login.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for the new mailbox.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox", "PrimaryAddress", "SmtpAddress")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The name of the new mailbox. If ommited the local part of the mail address is used.")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The authentcation source to use.")]
        [ValidateSet("mailcow", "Generic-OIDC", "Keycloak", "LDAP")]
        [System.String]
        $AuthSource = "mailcow",

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The password for the new mailbox user.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The mailbox state.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The mailbox quota in MB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Add a tag that can be used for filtering.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "The mailbox template to use.")]
        [System.String]
        $Template
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/mailbox"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Set name to the local part of th mail address, if it was not specified explicitly.
            if (-not $PSBoundParameters.ContainsKey("Name")) {
                $Name = $IdentityItem.User
            }

            # Prepare the request body.
            $Body = @{
                domain     = $IdentityItem.Host
                local_part = $IdentityItem.User
                password   = $Password | ConvertFrom-SecureString -AsPlainText
            }
            $Body.password2 = $Body.password

            if ($PSBoundParameters.ContainsKey("Name")) {
                if (-not [System.String]::IsNullOrEmpty($Name)) {
                    $Body.name = $Name.Trim()
                }
            }
            if ($PSBoundParameters.ContainsKey("AuthSource")) {
                if (-not [System.String]::IsNullOrEmpty($AuthSource)) {
                    $Body.authsource = $AuthSource.ToLower()
                }
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.quota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("ActiveState")) {
                $Body.active = "$($ActiveState.value__)"
            }
            if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
                $Body.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $Body.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $Body.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                if (-not [System.String]::IsNullOrEmpty($Tag)) {
                    $Body.tags = $Tag
                }
            }
            if ($PSBoundParameters.ContainsKey("Template")) {
                # If no template is specified, the API will use values from the default maibox template for values that have not been explicitly specified otherwise.
                if (-not [System.String]::IsNullOrEmpty($Template)) {
                    $Body.template = $Template
                }
            }

            if ($PSCmdlet.ShouldProcess("mailbox [$IdentityItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding mailbox [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
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
