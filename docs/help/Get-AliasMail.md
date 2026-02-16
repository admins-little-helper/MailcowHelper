---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasMail.md
schema: 2.0.0
---

# Get-MHAliasMail

## SYNOPSIS
Get information about one ore more alias mail addresses.

## SYNTAX

### AliasMail
```
Get-MHAliasMail [[-Identity] <MailAddress[]>] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AliasId
```
Get-MHAliasMail [-AliasId] <Int64[]> [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get information about one ore more alias mail addresses.

This function supports two parametersets.
Parameterset one allows to specify an alias email address for parameter "Identity".
Parameterset two allows to specify the ID of an alias for parameter "AliasID".

## EXAMPLES

### EXAMPLE 1
```
Get-MHMailAlias
```

Returns all aliases.

### EXAMPLE 2
```
Get-MHMailAlias -Identity alias@example.com
```

Returns information for alias@example.com

### EXAMPLE 3
```
Get-MHMailAlias -AliasId 158
```

Returns information for the alias with ID 158.

## PARAMETERS

### -AliasId
The ID number of the alias for which to get information.
If omitted, all aliases are returned.

```yaml
Type: Int64[]
Parameter Sets: AliasId
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Identity
The alias mail address or ID for which to get information.
If omitted, all alias domains are returned.

```yaml
Type: MailAddress[]
Parameter Sets: AliasMail
Aliases: Alias

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### -Raw
Return the result in raw format as returned by Invoke-WebRequest.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Net.Mail.MailAddress[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasMail.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasMail.md)

