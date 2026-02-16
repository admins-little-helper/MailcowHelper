function Set-IdPGenericOIDC {
    <#
    .SYNOPSIS
        Updates settings for a generic OIDC auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a generic OIDC auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a generic OIDC identity provider as auth source in mailcow.

    .PARAMETER AuthorizeUrl
        The provider's authorization server URL.

    .PARAMETER TokenUrl
        The provider's token server URL.

    .PARAMETER UserinfoUrl
        The provider's user info server URL.

    .PARAMETER ClientId
        The Client ID assigned to mailcow Client in OIDC provider.

    .PARAMETER ClientSecret
        The Client Secret assigned to the mailcow client in OIDC provider.

    .PARAMETER RedirectUrl
        The redirect URL that OIDC provider will use after authentication. This should point to your mailcow UI.

    .PARAMETER RedirectUrlExtra
        Additional redirect URL.

    .PARAMETER ClientScope
        Specifies the OIDC scopes requested during authentication.
        The default scopes are openid profile email mailcow_template

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation is bypassed.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .EXAMPLE
        $ClientSecret = Read-Host -AsSecureString

        Set-MHIdPGenericOIDC -AuthorizeUrl "https://auth.mailcow.tld/application/o/authorize/" -TokenUrl "https://auth.mailcow.tld/application/o/token/" -UserinfoUrl "https://auth.mailcow.tld/application/o/userinfo/" -ClientID "mailcow_client" -ClientSecret $ClientSecret -RedirectUrl "https://mail.mailcow.tld"

        Prompts for the client secret and stores in the variable $ClientSecret as secure string.
        Configures settings for using a generic OIDC as identity provider in mailcow.

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
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The provider's authorization server URL.")]
        [System.Uri]
        $AuthorizeUrl,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The provider's token server URL.")]
        [System.Uri]
        $TokenUrl,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The provider's user info server URL.")]
        [System.Uri]
        $UserinfoUrl,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The Client ID assigned to mailcow Client in OIDC provider.")]
        [System.String]
        $ClientId,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The Client Secret assigned to the mailcow client in OIDC provider.")]
        [System.Security.SecureString]
        $ClientSecret,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The redirect URL that OIDC provider will use after authentication. This should point to your mailcow UI.")]
        [System.Uri]
        $RedirectUrl,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Additional redirect URL.")]
        [System.Uri[]]
        $RedirectUrlExtra,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specifies the OIDC scopes requested during authentication.")]
        [System.String[]]
        $ClientScope = @("openid", "profile", "email", "mailcow_template"),

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation is bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/identity-provider"
    }

    process {
        # Get current configuration and use it as base. This allows to update only specific attributes and keep all other settings as is.
        $CurrentGenericOIDCConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "generic-oidc" }
        if ($null -ne $CurrentGenericOIDCConfig) {
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentGenericOIDCConfig
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "generic-oidc"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("AuthorizeUrl")) {
            $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("TokenUrl")) {
            $Body.attr.token_url = $TokenUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("UserinfoUrl")) {
            $Body.attr.userinfo_url = $UserinfoUrl.AbsoluteUri
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
            $Body.attr.redirect_url_extra = $RedirectUrlExtra.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("ClientScope")) {
            $Body.attr.client_scopes = $ClientScope
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
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.Keys) {
            if ($CurrentGenericOIDCConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentGenericOIDCConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentGenericOIDCConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentGenericOIDCConfig.$Key)] to [$($Body.attr.$Key)]."
                    $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("OIDC Identity Provider configuration", "Update")) {
            Write-MailcowHelperLog -Message "Updateing OIDC Identity Provider configuration." -Level Information

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
