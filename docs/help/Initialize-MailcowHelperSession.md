---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Initialize-MailcowHelperSession.md
schema: 2.0.0
---

# Initialize-MHMailcowHelperSession

## SYNOPSIS
Initializes a session to a mailcow server using the MailcowHelper module.

## SYNTAX

### Connect (Default)
```
Initialize-MHMailcowHelperSession [-DisableArgumentCompleter] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Disconnect
```
Initialize-MHMailcowHelperSession [-ClearSession] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Initializes a session to a mailcow server using the MailcowHelper module.
This is used to prepare the argument completers used for several functions in this module.

## EXAMPLES

### EXAMPLE 1
```
Initialize-MHMailcowHelperSession
```

Prepares the argument completers for all item types in the background.

### EXAMPLE 2
```
Initialize-MHMailcowHelperSession -DisableArgumentCompleter
```

Skips preparing all argument completers.

### EXAMPLE 3
```
Initialize-MHMailcowHelperSession -ClearSession
```

Cleares the module session variable and therefore removes all in-memory settings.

## PARAMETERS

### -ClearSession
Clears the module session variable and therefore removes all stored settings from memory.

```yaml
Type: SwitchParameter
Parameter Sets: Disconnect
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableArgumentCompleter
Disables all argument completers.
Argument completers for individual item types can also be disabled or enabled using the
"Enable-MailcowHelperArgumentCompleter" and "Disable-MailcowHelperArgumentCompleter" functions.

```yaml
Type: SwitchParameter
Parameter Sets: Connect
Aliases:

Required: False
Position: 1
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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### Nothing
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Initialize-MailcowHelperSession.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Initialize-MailcowHelperSession.md)

