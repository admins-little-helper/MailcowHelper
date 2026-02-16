---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdpLdap.md
schema: 2.0.0
---

# Set-MHIdpLdap

## SYNOPSIS
Updates settings for a LDAP auth source as an external identity provider in mailcow.

## SYNTAX

```
Set-MHIdpLdap [[-Hostname] <String[]>] [[-Port] <Object>] [-UseSsl] [-UseStartTls] [-IgnoreSslError]
 [[-BaseDN] <String>] [[-UsernameField] <String>] [[-LdapFilter] <String>] [[-AttributeField] <String>]
 [[-BindDN] <String>] [[-BindPassword] <SecureString>] [[-DefaultTemplate] <String>]
 [[-AttributeMapping] <Hashtable>] [-PeriodicSync] [-LoginProvisioning] [-ImportUsers]
 [[-SyncInterval] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates settings for a LDAP auth source as an external identity provider in mailcow.
In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
Only one identity provider can be active.
This function allows to configure settings for a LDAP identity providera as auth source in mailcow.

## EXAMPLES

### EXAMPLE 1
```
Set-MHIdpLdap -Hostname 1.2.3.4, 5.6.7.8 -UseSsl
```

Sets LDAP servers with IP addresses 1.2.3.4 and 5.6.7.8 and enables the usage of SSL.

## PARAMETERS

### -AttributeField
The name of the LDAP attribute in which to lookup the value defined in the attribute mapping.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Othermailbox
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttributeMapping
Specify an attribute value as key and a mailbox template name as value.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BaseDN
The Distinguished Name (DN) from which searches will be performed.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindDN
The Distinguished Name (DN) of the LDAP user that will be used to authenticate and perform LDAP searches.
This account should have sufficient permissions to read the required attributes.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BindPassword
The password for the Bind DN user.
It is required for authentication when connecting to the LDAP server.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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
Position: 12
Default value: Default
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
The name or IP address of a LDAP host.
Supports multiple values.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreSslError
If enabled, SSL certificate validation will be bypassed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ImportUsers
If enabled, new users will be automatically imported from LDAP into mailcow.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -LdapFilter
An optional LDAP search filter to refine which users can authenticate.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: (&(objectClass=user)
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
Position: 15
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PeriodicSync
If enabled, a full synchronization of all LDAP users and attributes will be performed periodically.

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

### -Port
The port used to connect to the LDAP server.
Defaults to port 389.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 389
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

### -SyncInterval
Defines the time interval (in minutes) for periodic synchronization and user imports.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: 15
Accept pipeline input: False
Accept wildcard characters: False
```

### -UsernameField
The LDAP attribute used to identify users during authentication.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Mail
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseSsl
Enable or disable LDAPS.
If port 389 is specified, enabling SSL will automatically use port 636 instead.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseStartTls
Enable or disable StartTLS.
SSL Ports cannot be used.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdpLdap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdpLdap.md)

