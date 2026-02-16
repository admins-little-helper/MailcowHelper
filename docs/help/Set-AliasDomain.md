---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasDomain.md
schema: 2.0.0
---

# Set-MHAliasDomain

## SYNOPSIS
Updates one or more alias domains.

## SYNTAX

```
Set-MHAliasDomain [-Identity] <String[]> [[-TargetDomain] <String>] [-Enable]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates one or more alias domains.

## EXAMPLES

### EXAMPLE 1
```
Set-MHAliasDomain -Identity "alias.example.com" -TargetDomain "example.com"
```

Sets the target domain to "example.com" for the existing alis domain "alias.example.com".

### EXAMPLE 2
```
Set-MHAliasDomain -Identity "alias.example.com" -Enable:$false
```

Disables the alias domain "alias.example.com".

## PARAMETERS

### -Enable
Enable or disable the alias domain.

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

### -Identity
The alias domain name.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: AliasDomain, Domain

Required: True
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

### -TargetDomain
The target domain for the  alias.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasDomain.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasDomain.md)

