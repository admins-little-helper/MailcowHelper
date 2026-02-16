---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RateLimit.md
schema: 2.0.0
---

# Remove-MHRateLimit

## SYNOPSIS
Remove the rate limit for one or more mailboxs or domains.

## SYNTAX

### Mailbox
```
Remove-MHRateLimit [-Mailbox] <MailAddress[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Domain
```
Remove-MHRateLimit [-Domain] <String[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Remove the rate limit for one or more mailboxs or domains.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHRateLimit -Mailbox "user123@example.com"
```

Removes the rate limit for mailbox of user "user123@example.com".

### EXAMPLE 2
```
Remove-MHRateLimit -Domain "example.com"
```

Removes the rate limit for domain "example.com".

## PARAMETERS

### -Domain
The name of the domain for which to remove the rate-limit setting.

```yaml
Type: String[]
Parameter Sets: Domain
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Mailbox
The mail address of the mailbox for which to remove the rate-limit setting.

```yaml
Type: MailAddress[]
Parameter Sets: Mailbox
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
### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RateLimit.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RateLimit.md)

