---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-IdentityProvider.md
schema: 2.0.0
---

# Get-MHIdentityProvider

## SYNOPSIS
Returns the identity provider configuration of the authentication source that is currently set in mailcow.

## SYNTAX

```
Get-MHIdentityProvider [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Returns the identity provider configuration of the authentication source that is currently set in mailcow.
In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
Only one identity provider can be active.
This function returns the settings of the identity provider that is currently set as the active identity provider.

## EXAMPLES

### EXAMPLE 1
```
Get-MHIdentityProvider
```

Returns the configuration of the currently active identity provider in mailcow.

## PARAMETERS

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

### -Raw
Return the result in raw format as returned by Invoke-WebRequest.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-IdentityProvider.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-IdentityProvider.md)

