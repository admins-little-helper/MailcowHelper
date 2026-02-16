---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Ratelimit.md
schema: 2.0.0
---

# Get-MHRatelimit

## SYNOPSIS
Get the rate limit for one or more mailboxes or domains.

## SYNTAX

### Mailbox
```
Get-MHRatelimit [-Mailbox] <MailAddress[]> [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AllMailboxes
```
Get-MHRatelimit [-AllMailboxes] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Domain
```
Get-MHRatelimit [-Domain] <String[]> [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AllDomains
```
Get-MHRatelimit [-AllDomains] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get the rate limit for one or more mailboxes or domains.

## EXAMPLES

### EXAMPLE 1
```
Get-MHRatelimit
```

By default, the rate-limit settings for all mailboxes are returned.

### EXAMPLE 2
```
Get-MHRatelimit -AllMailboxes
```

Returns the rate limit settings for all mailboxes for which a rate-limit is set.

### EXAMPLE 3
```
Get-MHRatelimit -Domain "example.com"
```

Returns the rate-limit settings for the domain "example.com".

### EXAMPLE 4
```
Get-MHRatelimit -AllDomains
```

Returns the rate limit for all domains for which a rate-limit is set.

## PARAMETERS

### -AllDomains
If specified, get rate-limit information for all domains.

```yaml
Type: SwitchParameter
Parameter Sets: AllDomains
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllMailboxes
If specified, get rate-limit information for all mailboxes.

```yaml
Type: SwitchParameter
Parameter Sets: AllMailboxes
Aliases:

Required: False
Position: 1
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The name of the domain for which to get rate-limit information.

```yaml
Type: String[]
Parameter Sets: Domain
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Mailbox
The mail address for which to get rate-limit information.

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
### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Ratelimit.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Ratelimit.md)

