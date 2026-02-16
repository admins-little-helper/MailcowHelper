---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveGlobalFilter.md
schema: 2.0.0
---

# Set-MHSieveGlobalFilter

## SYNOPSIS
Updates a global Sieve filter script.

## SYNTAX

```
Set-MHSieveGlobalFilter [-FilterType] <String> [-SieveScriptContent] <String>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates a global Sieve filter script.
Note that mailcow"s Dovecot service will be restartet automatically to apply the new filter.

## EXAMPLES

### EXAMPLE 1
```
Set-MHSieveGlobalFilter -FilterType PreFilter -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)
```

Creates a new global prefilter filter script on the mailcow server.
The script is loaded from text file ".\PreviouslySavedScript.txt".

## PARAMETERS

### -FilterType
The type of the filter script.
Valid values are:
PreFilter, PostFilter

```yaml
Type: String
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

### -SieveScriptContent
The Sieve script.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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

### System.Net.Mail.MailAddress[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveGlobalFilter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveGlobalFilter.md)

