---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasTimeLimited.md
schema: 2.0.0
---

# Get-MHAliasTimeLimited

## SYNOPSIS
Get information about all time-limited aliases (spam-alias) defined for a mailbox.

## SYNTAX

```
Get-MHAliasTimeLimited [[-Identity] <MailAddress[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Get information about all time-limited aliases (spam-alias) defined for a mailbox.

## EXAMPLES

### EXAMPLE 1
```
Get-MHAliasTimeLimited
```

Returns time-limited aliases for all mailboxes.

### EXAMPLE 2
```
Get-MHAliasTimeLimited -Identity user@example.com
```

Returns time-limited alias(es) for the mailbox user@example.com.

## PARAMETERS

### -Identity
The mail address of the mailbox for which to get the time-limited alias(es).
If omitted, all time-limited aliases for all mailboxes are returned.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Mailbox

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasTimeLimited.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasTimeLimited.md)

