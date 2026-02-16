---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasTimeLimited.md
schema: 2.0.0
---

# Set-MHAliasTimeLimited

## SYNOPSIS
Updates one or more time-limited aliases (spamalias).

## SYNTAX

### ExpireIn (Default)
```
Set-MHAliasTimeLimited [-Identity] <MailAddress[]> [-ExpireIn] <String> [-ProgressAction <ActionPreference>]
 [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Permanent
```
Set-MHAliasTimeLimited [-Identity] <MailAddress[]> [-Permanent] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### ExpireInHours
```
Set-MHAliasTimeLimited [-Identity] <MailAddress[]> [-ExpireInHours] <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates one or more time-limited aliases (spamalias).

## EXAMPLES

### EXAMPLE 1
```
Set-MHAliasTimeLimited -Identity "alias@example.com" -Permanent
```

Set the alias "alias@example.com" to not expire.

### EXAMPLE 2
```
Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireIn "1Week"
```

Set the alias "alias@example.com" to expire in 1 week from now.

### EXAMPLE 3
```
Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireInHours 48
```

Set the alias "alias@example.com" to expire in 48 hours from now.

## PARAMETERS

### -ExpireIn
Set a predefined time period.
Allowed values are:
1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

```yaml
Type: String
Parameter Sets: ExpireIn
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireInHours
Set a custom value as number of hours from now.
The valid range is 1 to 105200, which is between 1 hour and about 12 years.

```yaml
Type: Int32
Parameter Sets: ExpireInHours
Aliases:

Required: True
Position: 2
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The time-limited alias mail address to be updated.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Alias

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Permanent
If specified, the time-limit alias will be set to never expire.

```yaml
Type: SwitchParameter
Parameter Sets: Permanent
Aliases:

Required: True
Position: 2
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

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasTimeLimited.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasTimeLimited.md)

