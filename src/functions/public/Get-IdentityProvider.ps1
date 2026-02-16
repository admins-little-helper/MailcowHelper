function Get-IdentityProvider {
    <#
    .SYNOPSIS
        Returns the identity provider configuration of the authentication source that is currently set in mailcow.

    .DESCRIPTION
        Returns the identity provider configuration of the authentication source that is currently set in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function returns the settings of the identity provider that is currently set as the active identity provider.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHIdentityProvider

        Returns the configuration of the currently active identity provider in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-IdentityProvider.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/identity-provider"
    }

    process {
        # Build full Uri.
        $RequestUriPath = $UriPath

        # Execute the API call.
        $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

        # Return result.
        if ($Raw.IsPresent -or $Result.authsource -ne "ldap") {
            # Return the result in raw format.
            # Currently a custom format is only available for LDAP auth source.
            $Result
        }
        else {
            switch ($Result.authsource) {
                "generic-oidc" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            AuthorizeUrl      = $Item.authorize_url
                            TokenUrl          = $Item.token_url
                            UserinfoUrl       = $Item.userinfo_url
                            ClientId          = $Item.client_id
                            ClientSecret      = $Item.client_secret
                            RedirectUrl       = $Item.redirect_url
                            RedirectUrlExtra  = $Item.redirect_url_extra
                            ClientScope       = $Item.client_scopes
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPGenericOIDCConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                "keycloak" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            ServerUrl         = $Item.server_url
                            Realm             = $Item.realm
                            ClientId          = $Item.client_id
                            ClientSecret      = $Item.client_secret
                            RedirectUrl       = $Item.redirect_url
                            RedirectUrlExtra  = $Item.redirect_url_extra
                            Version           = $Item.version
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            MailpasswordFlow  = $Item.mailpassword_flow
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            PeriodicSync      = [System.Boolean][System.Int32]$Item.periodic_sync
                            SyncInterval      = $Item.sync_interval
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPKeycloakConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                "ldap" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            Host              = $Item.host
                            Port              = $Item.port
                            BaseDn            = $Item.basedn
                            BindDn            = $Item.binddn
                            BindPass          = $Item.bindpass
                            Filter            = $Item.filter
                            UsernameField     = $Item.username_field
                            AttributeField    = $Item.attribute_field
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            PeriodicSync      = [System.Boolean][System.Int32]$Item.periodic_sync
                            SyncInterval      = $Item.sync_interval
                            UseSsl            = [System.Boolean][System.Int32]$Item.use_ssl
                            UseTls            = [System.Boolean][System.Int32]$Item.use_tls
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPLDAPConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                default {
                    # Unknown IdP provider. Return raw result.
                    Write-MailcowHelperLog -Message "Unknown IdP authsource [$($Result.authsource)]. Return raw result." -Level Warning
                    $Result
                }
            }
        }
    }
}
