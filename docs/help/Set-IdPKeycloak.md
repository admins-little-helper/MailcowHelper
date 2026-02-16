---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md
schema: 2.0.0
---

# Set-MHIdPKeycloak

## SYNOPSIS
Updates settings for a Keycloak auth source as an external identity provider in mailcow.

## SYNTAX

```
Set-MHIdPKeycloak [[-ServerUrl] <Uri>] [[-Realm] <String>] [[-ClientId] <String>]
 [[-ClientSecret] <SecureString>] [[-RedirectUrl] <Uri>] [[-RedirectUrlExtra] <Uri[]>] [[-Version] <String>]
 [[-DefaultTemplate] <String>] [[-AttributeMapping] <Hashtable>] [-IgnoreSslError] [-MailpasswordFlow]
 [-PeriodicSync] [-LoginProvisioning] [-ImportUsers] [[-SyncInterval] <Int32>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates settings for a Keycloak auth source as an external identity provider in mailcow.
In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
Only one identity provider can be active.
This function allows to configure settings for a Keycloak identity provider as auth source in mailcow.

## EXAMPLES

### EXAMPLE 1
```
$ClientSecret = Read-Host -AsSecureString
```

Set-MHIdPKeycloak -ServerUrl "https://auth.mailcow.tld" -RedirectUrl "https://mail.mailcow.tld" -Realm "mailcow" -ClientID "mailcow_client" -Version "26.1.3"

Prompts for the client secret and stores in the variable $ClientSecret as secure string.
Configures settings for using Keycloak as identity provider in mailcow.

## PARAMETERS

### -AttributeMapping
Specify an attribute value as key and a mailbox template name as value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientId
The Client ID assigned to mailcow Client in Keycloak.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientSecret
The Client Secret assigned to the mailcow client in Keycloak.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
Position: 8
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
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportUsers
If enabled, new users are automatically imported from Keycloak into mailcow.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
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
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailpasswordFlow
If enabled, mailcow will attempt to validate user credentials using the Keycloak Admin REST API instead of relying solely on the Authorization Code Flow.

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

### -PeriodicSync
If enabled, mailcow periodically performs a full sync of all users from Keycloak.

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

### -Realm
The Keycloak realm where the mailcow client is configured.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RedirectUrl
The redirect URL that Keycloak will use after authentication.
This should point to your mailcow UI.

```yaml
Type: Uri
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
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
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ServerUrl
The base URL of the Keycloak server.

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

### -SyncInterval
Defines the time interval (in minutes) for periodic synchronization and user imports.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -Version
Specifies the Keycloak version.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
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

