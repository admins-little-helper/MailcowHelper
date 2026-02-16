---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AppPassword.md
schema: 2.0.0
---

# Remove-MHAppPassword

## SYNOPSIS
Deletes one or more appliation-specific passwords.

## SYNTAX

```
Remove-MHAppPassword [-Id] <Int32[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Deletes one or more appliation-specific passwords.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHAppPassword -Identity 17
```

Deletes app password with ID 17.

### EXAMPLE 2
```
Get-AppPassword -Identity "user1@example.com" | Remove-MHAppPassword
```

Deletes all app passwords configured for the mailbox of "user1@example.com".

## PARAMETERS

### -Id
The app password id.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: AppPasswordId

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

### System.Int32[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AppPassword.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AppPassword.md)

