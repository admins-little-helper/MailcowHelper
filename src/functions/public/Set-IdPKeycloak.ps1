function Set-IdPKeycloak {
    <#
    .SYNOPSIS
        Updates settings for a Keycloak auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a Keycloak auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a Keycloak identity provider as auth source in mailcow.

    .PARAMETER ServerUrl
        The base URL of the Keycloak server.

    .PARAMETER Realm
        The Keycloak realm where the mailcow client is configured.

    .PARAMETER ClientId
        The Client ID assigned to mailcow Client in Keycloak.

    .PARAMETER ClientSecret
        The Client Secret assigned to the mailcow client in Keycloak.

    .PARAMETER RedirectUrl
        The redirect URL that Keycloak will use after authentication. This should point to your mailcow UI.

    .PARAMETER RedirectUrlExtra
        Additional redirect URL.

    .PARAMETER Version
        Specifies the Keycloak version.

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation is bypassed.

    .PARAMETER MailpasswordFlow
        If enabled, mailcow will attempt to validate user credentials using the Keycloak Admin REST API instead of relying solely on the Authorization Code Flow.

    .PARAMETER PeriodicSync
        If enabled, mailcow periodically performs a full sync of all users from Keycloak.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .PARAMETER ImportUsers
        If enabled, new users are automatically imported from Keycloak into mailcow.

    .PARAMETER SyncInterval
        Defines the time interval (in minutes) for periodic synchronization and user imports.

    .EXAMPLE
        $ClientSecret = Read-Host -AsSecureString

        Set-MHIdPKeycloak -ServerUrl "https://auth.mailcow.tld" -RedirectUrl "https://mail.mailcow.tld" -Realm "mailcow" -ClientID "mailcow_client" -Version "26.1.3"

        Prompts for the client secret and stores in the variable $ClientSecret as secure string.
        Configures settings for using Keycloak as identity provider in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The base URL of the Keycloak server.")]
        [System.Uri]
        $ServerUrl,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The Keycloak realm where the mailcow client is configured.")]
        [System.String]
        $Realm,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The Client ID assigned to mailcow Client in Keycloak.")]
        [System.String]
        $ClientId,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The Client Secret assigned to the mailcow client in Keycloak.")]
        [System.Security.SecureString]
        $ClientSecret,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The redirect URL that Keycloak will use after authentication. This should point to your mailcow UI.")]
        [System.Uri]
        $RedirectUrl,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Additional redirect URL.")]
        [System.Uri[]]
        $RedirectUrlExtra,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specifies the Keycloak version.")]
        [System.String]
        $Version,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation is bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "If enabled, mailcow will attempt to validate user credentials using the Keycloak Admin REST API instead of relying solely on the Authorization Code Flow.")]
        [System.Management.Automation.SwitchParameter]
        $MailpasswordFlow,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "If enabled, mailcow periodically performs a full sync of all users from Keycloak.")]
        [System.Management.Automation.SwitchParameter]
        $PeriodicSync,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "If enabled, new users are automatically imported from Keycloak into mailcow.")]
        [System.Management.Automation.SwitchParameter]
        $ImportUsers,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Defines the time interval (in minutes) for periodic synchronization and user imports.")]
        [System.Int32]
        [ValidateRange(1, 1440)]
        $SyncInterval = 15
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/identity-provider"
    }

    process {
        # Get current configuration and use it as base. This allows to update only specific attributes and keep all other settings as is.
        $CurrentKeycloakConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "keycloak" }
        if ($null -ne $CurrentKeycloakConfig) {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentKeycloakConfig
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "keycloak"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("ServerUrl")) {
            $Body.attr.server_url = $ServerUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("Realm")) {
            $Body.attr.realm = $Realm.Trim()
        }
        if ($PSBoundParameters.ContainsKey("ClientId")) {
            $Body.attr.client_id = $ClientId.Trim()
        }
        if ($PSBoundParameters.ContainsKey("ClientSecret")) {
            $Body.attr.client_secret = $ClientSecret | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrl")) {
            $Body.attr.redirect_url = $RedirectUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrlExtra")) {
            $Body.attr.redirect_url_extra = foreach ($RedirectUrlExtraItem in $RedirectUrlExtra) { $RedirectUrlExtraItem.AbsoluteUri }
        }
        if ($PSBoundParameters.ContainsKey("Version")) {
            $Body.attr.version = $Version.Trim()
        }
        if ($PSBoundParameters.ContainsKey("DefaultTemplate")) {
            $Body.attr.default_template = $DefaultTemplate
        }
        if ($PSBoundParameters.ContainsKey("AttributeMapping")) {
            $Body.attr.mappers = $AttributeMapping.Keys
            $Body.attr.templates = $AttributeMapping.Values
        }
        if ($PSBoundParameters.ContainsKey("IgnoreSslError")) {
            $Body.attr.ignore_ssl_error = if ($IgnoreSslError.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MailpasswordFlow")) {
            $Body.attr.mailpassword_flow = if ($MailpasswordFlow.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PeriodicSync")) {
            $Body.attr.periodic_sync = if ($PeriodicSync.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImportUsers")) {
            $Body.attr.import_users = if ($ImportUsers.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SyncInterval")) {
            $Body.attr.sync_interval = $SyncInterval.ToString()
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.Keys) {
            if ($CurrentKeycloakConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentKeycloakConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentKeycloakConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentKeycloakConfig.$Key)] to [$($Body.attr.$Key)]."
                    $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("Keycloak Identity Provider configuration.", "Update")) {
            Write-MailcowHelperLog -Message "Updating Keycloak Identity Provider configuration." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            if ($Result.type -eq "danger" -and $Result.msg -contains "authsource_in_use") {
                # The error "authsource_in_use" means that currently another authentiation source / identity provider is configured and used by at least one mailbox.
                Write-MailcowHelperLog -Message "Currently another authentiation source / identity provider is configured and used by at least one mailbox." -Level Warning
            }
            $Result
        }
    }
}
