function Set-IdpLdap {
    <#
    .SYNOPSIS
        Updates settings for a LDAP auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a LDAP auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a LDAP identity providera as auth source in mailcow.

    .PARAMETER Hostname
        The name or IP address of a LDAP host. Supports multiple values.

    .PARAMETER Port
        The port used to connect to the LDAP server. Defaults to port 389.

    .PARAMETER UseSsl
        Enable or disable LDAPS. If port 389 is specified, enabling SSL will automatically use port 636 instead.

    .PARAMETER UseStartTls
        Enable or disable StartTLS. SSL Ports cannot be used.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation will be bypassed.

    .PARAMETER BaseDN
        The Distinguished Name (DN) from which searches will be performed.

    .PARAMETER UsernameField
        The LDAP attribute used to identify users during authentication.

    .PARAMETER LdapFilter
        An optional LDAP search filter to refine which users can authenticate.

    .PARAMETER AttributeField
        The name of the LDAP attribute in which to lookup the value defined in the attribute mapping.

    .PARAMETER BindDN
        The Distinguished Name (DN) of the LDAP user that will be used to authenticate and perform LDAP searches.
        This account should have sufficient permissions to read the required attributes.

    .PARAMETER BindPassword
        The password for the Bind DN user. It is required for authentication when connecting to the LDAP server.

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER PeriodicSync
        If enabled, a full synchronization of all LDAP users and attributes will be performed periodically.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .PARAMETER ImportUsers
        If enabled, new users will be automatically imported from LDAP into mailcow.

    .PARAMETER SyncInterval
        Defines the time interval (in minutes) for periodic synchronization and user imports.

    .EXAMPLE
        Set-MHIdpLdap -Hostname 1.2.3.4, 5.6.7.8 -UseSsl

        Sets LDAP servers with IP addresses 1.2.3.4 and 5.6.7.8 and enables the usage of SSL.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdpLdap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The name or IP address of a LDAP host.")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The port used to connect to the LDAP server.")]
        [ValidateRange(1, 65535)]
        $Port = 389,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable LDAPS. If port 389 is specified, enabling SSL will automatically use port 636 instead.")]
        [System.Management.Automation.SwitchParameter]
        $UseSsl,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable StartTLS. SSL Ports cannot be used.")]
        [System.Management.Automation.SwitchParameter]
        $UseStartTls,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation will be bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The Distinguished Name (DN) from which searches will be performed.")]
        [System.String]
        $BaseDN,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The LDAP attribute used to identify users during authentication.")]
        [System.String]
        $UsernameField = "mail",

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "An optional LDAP search filter to refine which users can authenticate.")]
        [System.String]
        $LdapFilter = "(&(objectClass=user)",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The name of the LDAP attribute in which to lookup the value defined in the attribute mapping.")]
        [System.String]
        $AttributeField = "othermailbox",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "The Distinguished Name (DN) of the LDAP user that will be used to authenticate and perform LDAP searches.")]
        [System.String]
        $BindDN,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "The password for the Bind DN user. It is required for authentication when connecting to the LDAP server.")]
        [System.Security.SecureString]
        $BindPassword,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "If enabled, a full synchronization of all LDAP users and attributes will be performed periodically.")]
        [System.Management.Automation.SwitchParameter]
        $PeriodicSync,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "If enabled, new users will be automatically imported from LDAP into mailcow.")]
        [System.Management.Automation.SwitchParameter]
        $ImportUsers,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Defines the time interval (in minutes) for periodic synchronization and user imports.")]
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
        $CurrentLdapConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "ldap" }

        if ($null -ne $CurrentLdapConfig) {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentLdapConfig | ConvertTo-Json | ConvertFrom-Json
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "ldap"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.host = $Hostname.Trim() -join ","
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BaseDN")) {
            $Body.attr.basedn = $BaseDN.Trim()
        }
        if ($PSBoundParameters.ContainsKey("UsernameField")) {
            $Body.attr.username_field = $UsernameField.Trim()
        }
        if ($PSBoundParameters.ContainsKey("LdapFilter")) {
            $Body.attr.filter = $LdapFilter.Trim()
        }
        if ($PSBoundParameters.ContainsKey("AttributeField")) {
            $Body.attr.attribute_field = $AttributeField.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BindDN")) {
            $Body.attr.binddn = $BindDN.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BindPassword")) {
            $Body.attr.bindpass = $BindPassword | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("DefaultTemplate")) {
            $Body.attr.default_template = $DefaultTemplate
        }
        if ($PSBoundParameters.ContainsKey("UseSsl")) {
            $Body.attr.use_ssl = if ($UseSsl.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("UseStartTls")) {
            $Body.attr.use_tls = if ($UseStartTls.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("IgnoreSslError")) {
            $Body.attr.ignore_ssl_error = if ($IgnoreSslError.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PeriodicSync")) {
            $Body.attr.periodic_sync = if ($PeriodicSync.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImportUsers")) {
            $Body.attr.import_users = $ImportUsers.IsPresent
        }
        if ($PSBoundParameters.ContainsKey("SyncInterval")) {
            $Body.attr.sync_interval = $SyncInterval.ToString()
        }
        if ($PSBoundParameters.ContainsKey("AttributeMapping")) {
            $Body.attr.mappers = $AttributeMapping.Keys
            $Body.attr.templates = $AttributeMapping.Values
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.PSObject.Properties.Name) {
            if ($CurrentLdapConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentLdapConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentLdapConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentLdapConfig.$Key)] to [$($Body.attr.$Key)]."
                }
            }
            else {
                Write-MailcowHelperLog -Message "Attribute not found in base [$Key]. Setting it to value [$($Body.attr.$Key)]."
            }
        }

        if ($PSCmdlet.ShouldProcess("LDAP Identity Provider configuration.", "Update")) {
            Write-MailcowHelperLog -Message "Updateing LDAP Identity Provider configuration." -Level Information

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
