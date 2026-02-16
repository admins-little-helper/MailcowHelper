---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DkimKey.md
schema: 2.0.0
---

# Remove-MHDkimKey

## SYNOPSIS
Deletes a DKIM key for one or more domains.

## SYNTAX

```
Remove-MHDkimKey [-Domain] <String[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes a DKIM key for one or more domains.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHDkimKey -Domain "example.com"
```

Deletes the DKIM key for the domain "example.com".

## PARAMETERS

### -Domain
The name of the domain for which to delete the DKIM key.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DkimKey.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DkimKey.md)

