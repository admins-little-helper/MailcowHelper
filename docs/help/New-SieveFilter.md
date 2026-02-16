---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SieveFilter.md
schema: 2.0.0
---

# New-MHSieveFilter

## SYNOPSIS
Create a new admin defined Sieve filter for one or more mailboxes.

## SYNTAX

```
New-MHSieveFilter [-Identity] <MailAddress[]> [-FilterType] <String> [[-Description] <String>]
 [-SieveScriptContent] <String> [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Create a new admin defined Sieve filter for one or more mailboxes.
Note that filter definitions created by this function/API call will only show up in the admin GUI (E-Mail / Configuration / Filters).
A user will not see this filter in SOGo.

## EXAMPLES

### EXAMPLE 1
```
New-MHSieveFilter -Identity "user1@example.com" -FilterType PreFilter -Description "A new filter" -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)
```

Creates a new prefilter filter script for user "user1@example.com".
The script is loaded from text file ".\PreviouslySavedScript.txt".

## PARAMETERS

### -Description
A description for the new sieve filter script.

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

### -Enable
Enable or disable the new filter script.

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

### -FilterType
Either PreFilter or PostFilter.

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

### -Identity
The mail address of the mailbox for which to create a filter script.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

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

### -SieveScriptContent
The Sieve script.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SieveFilter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SieveFilter.md)

