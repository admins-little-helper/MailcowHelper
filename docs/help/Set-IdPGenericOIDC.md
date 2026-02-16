---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md
schema: 2.0.0
---

# Set-MHIdPGenericOIDC

## SYNOPSIS
Updates settings for a generic OIDC auth source as an external identity provider in mailcow.

## SYNTAX

```
Set-MHIdPGenericOIDC [[-AuthorizeUrl] <Uri>] [[-TokenUrl] <Uri>] [[-UserinfoUrl] <Uri>] [[-ClientId] <String>]
 [[-ClientSecret] <SecureString>] [[-RedirectUrl] <Uri>] [[-RedirectUrlExtra] <Uri[]>]
 [[-ClientScope] <String[]>] [[-DefaultTemplate] <String>] [[-AttributeMapping] <Hashtable>] [-IgnoreSslError]
 [-LoginProvisioning] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates settings for a generic OIDC auth source as an external identity provider in mailcow.
In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
Only one identity provider can be active.
This function allows to configure settings for a generic OIDC identity provider as auth source in mailcow.

## EXAMPLES

### EXAMPLE 1
```
$ClientSecret = Read-Host -AsSecureString
```

Set-MHIdPGenericOIDC -AuthorizeUrl "https://auth.mailcow.tld/application/o/authorize/" -TokenUrl "https://auth.mailcow.tld/application/o/token/" -UserinfoUrl "https://auth.mailcow.tld/application/o/userinfo/" -ClientID "mailcow_client" -ClientSecret $ClientSecret -RedirectUrl "https://mail.mailcow.tld"

Prompts for the client secret and stores in the variable $ClientSecret as secure string.
Configures settings for using a generic OIDC as identity provider in mailcow.

## PARAMETERS

### -AttributeMapping
Specify an attribute value as key and a mailbox template name as value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AuthorizeUrl
The provider's authorization server URL.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The Client ID assigned to mailcow Client in OIDC provider.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientScope
Specifies the OIDC scopes requested during authentication.
The default scopes are openid profile email mailcow_template

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: @("openid", "profile", "email", "mailcow_template")
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The Client Secret assigned to the mailcow client in OIDC provider.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DefaultTemplate
The name of the default template to use for creating a mailbox.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreSslError
If enabled, SSL certificate validation is bypassed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LoginProvisioning
Provision mailcow mailbox on user login.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUrl
The redirect URL that OIDC provider will use after authentication.
This should point to your mailcow UI.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUrlExtra
Additional redirect URL.

```yaml
Type: Uri[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TokenUrl
The provider's token server URL.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserinfoUrl
The provider's user info server URL.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md)

