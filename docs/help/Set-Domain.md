---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Domain.md
schema: 2.0.0
---

# Set-MHDomain

## SYNOPSIS
Update one or more domains on the mailcow server.

## SYNTAX

```
Set-MHDomain [-Identity] <String[]> [[-Description] <String>] [-Enable] [[-MaxMailboxCount] <Int32>]
 [[-MaxAliasCount] <Int32>] [[-DefaultMailboxQuotaMB] <Int64>] [[-MaxMailboxQuotaMB] <Int64>]
 [[-TotalDomainQuotaMB] <Int64>] [-GlobalAddressList] [-RelayThisDomain] [-RelayAllRecipients]
 [-RelayUnknownOnly] [[-Tag] <String[]>] [[-RateLimit] <Int64>] [[-RateLimitPerUnit] <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update one or more domains on the mailcow server.

## EXAMPLES

### EXAMPLE 1
```
Set-MHDomain -Domain "example.com" -MaxMailboxCount 100
```

Sets the mailbox count value for the domain "example.com" to 100.

## PARAMETERS

### -DefaultMailboxQuotaMB
Default mailbox quota accepts max 8 Exabyte.

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
A description for the domain.

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

### -Identity
The domain name to add.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Domain

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
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

### -MaxMailboxQuotaMB
Max.
mailbox quota accepts max 8 Exabyte.

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
Enable or disable the relaying for the domain created.

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

### -Tag
Add a tag to the new domain.

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

### -TotalDomainQuotaMB
Total domain quota accepts max 8 Exabyte.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Domain.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Domain.md)

