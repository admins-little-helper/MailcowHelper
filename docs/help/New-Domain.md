---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Domain.md
schema: 2.0.0
---

# New-MHDomain

## SYNOPSIS
Add a domain to mailcow server.

## SYNTAX

```
New-MHDomain [-Domain] <String[]> [[-Description] <String>] [-Enable] [[-MaxMailboxCount] <Int32>]
 [[-MaxAliasCount] <Int32>] [[-DefaultMailboxQuota] <Int64>] [[-MailboxQuota] <Int64>]
 [[-TotalDomainQuota] <Int64>] [-GlobalAddressList] [-RelayThisDomain] [-RelayAllRecipients]
 [-RelayUnknownOnly] [[-Tag] <String[]>] [[-RateLimit] <Int64>] [[-RateLimitPerUnit] <String>] [-RestartSogo]
 [[-Template] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a domain to mailcow server.

## EXAMPLES

### EXAMPLE 1
```
New-MHDomain -Domain "example.com"
```

Adds a new domain "example.com" to the mailcow server using default values from the default template.

### EXAMPLE 2
```
New-MHDomain -Domain "example.com" -Template "MyTemplate"
```

Adds a new domain "example.com" to the mailcow server using default values from the "MyTemplate" domain template.

## PARAMETERS

### -DefaultMailboxQuota
Specify the default mailbox quota.
Defaults to 3072.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: 3072
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description for the new domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Domain
The domain name to add.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Enable
Enable or disable the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -GlobalAddressList
Enable or disable the Global Address list for the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailboxQuota
Specify the maximum mailbox quota.
Defaults to 10240.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 10240
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxAliasCount
Specify the maximum number of aliases allowed for the domain.
Defaults to 400.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 400
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxMailboxCount
Specify the maximum number of mailboxes allowed for the domain.
Defaults to 10.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 10
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

### -RateLimit
Set the message rate limit for the domain.
Defaults to 10.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimitPerUnit
Set the message rate limit unit.
Defaults to seconds.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: Seconds
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayAllRecipients
Enable or disable the relaying for all recipients for the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayThisDomain
Enable or disable the relaying for the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayUnknownOnly
Enable or disable the relaying for unknown recipients for the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RestartSogo
If specified, SOGo will be restarted after adding the domain.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
Add one or more tags to the new domain.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Template
The name of a domain template to use to get default values based on the template.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TotalDomainQuota
Specify the total domain quota valid for all mailboxes in the domain.
Defaults to 10240.

```yaml
Type: Int64
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 10240
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Domain.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Domain.md)

