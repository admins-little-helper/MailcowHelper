---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveFilter.md
schema: 2.0.0
---

# Get-MHSieveFilter

## SYNOPSIS
Returns admin defined Sieve filters for one or more user mailboxes.

## SYNTAX

```
Get-MHSieveFilter [[-Identity] <MailAddress[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Returns admin defined Sieve filters for user mailboxes.
Note that this will NOT return sieve filter scripts that a user has created on his/her own in SOGo,
like out-of-office/vacation auto-reply or for example filter scripts to move incoming mails to folders.

## EXAMPLES

### EXAMPLE 1
```
Get-MHSieveFilter -Identity "user1@example.com"
```

Returns Sieve scripts for the mailbox of "user1@example.com"

## PARAMETERS

### -Identity
The mail address of the mailbox for which to return the Sieve script(s).
If ommited, Sieve scripts for all mailboxes are returned.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveFilter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveFilter.md)

