---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RateLimit.md
schema: 2.0.0
---

# Set-MHRateLimit

## SYNOPSIS
Updates the rate limit for one or more mailboxes or domains.

## SYNTAX

### Mailbox
```
Set-MHRateLimit [-Mailbox] <MailAddress[]> [-RateLimitValue] <Int32> [[-RateLimitFrame] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Domain
```
Set-MHRateLimit [-Domain] <String[]> [-RateLimitValue] <Int32> [[-RateLimitFrame] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates the rate limit for one or more mailboxes or domains.

## EXAMPLES

### EXAMPLE 1
```
Set-MHRateLimit -Mailbox "user123@example.com" -RateLimitValue 10 -RateLimitFrame Minute
```

Set the rate-limit for mailbox of user "user123@example.com" to 10 messages per minute.

### EXAMPLE 2
```
Set-MHRateLimit -Domain "example.com" -RateLimitValue 1000 -RateLimitFrame Hour
```

Set the rate-limit for domain "example.com" to 1000 messages per hour.

## PARAMETERS

### -Domain
The name of the domain for which to set the rate-limit setting.

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
The mail address of the mailbox for which to set the rate-limit setting.

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

### -RateLimitFrame
The rate limit unit.
Valid values are:
Second, Minute, Hour, Day

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Hour
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimitValue
The rate limite value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: 0
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RateLimit.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RateLimit.md)

