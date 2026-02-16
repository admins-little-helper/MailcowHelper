---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainTemplate.md
schema: 2.0.0
---

# Set-MHDomainTemplate

## SYNOPSIS
Updates one or more domain templates.

## SYNTAX

```
Set-MHDomainTemplate [-Id] <Int64[]> [[-Name] <String>] [[-MaxNumberOfAliasesForDomain] <Int32>]
 [[-MaxNumberOfMailboxesForDomain] <Int32>] [[-DefaultMailboxQuota] <Int32>] [[-MaxMailboxQuota] <Int32>]
 [[-MaxDomainQuota] <Int32>] [[-Tag] <String[]>] [[-RateLimitValue] <Int32>] [[-RateLimitFrame] <String>]
 [[-DkimSelector] <String>] [[-DkimKeySize] <Int32>] [-Enable] [-GlobalAddressList] [-RelayThisDomain]
 [-RelayAllRecipients] [-RelayUnknownOnly] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates one or more domain templates.
A domain template can either be specified as a default template for a new domain.
Or you can select a template when creating a new mailbox to inherit some properties.

## EXAMPLES

### EXAMPLE 1
```
Set-MHDomainTemplate -Name "MyDefaultDomainTemplate"
```

Creates a domain template with the name "MyDefaultDomainTemplate".
All values are set to mailcow defaults.

### EXAMPLE 2
```
Set-MHDomainTemplate -Name "MyDefaultDomainTemplate" -MaxNumberOfAliasesForDomain 1000 -MaxNumberOfMailboxesForDomain 1000 -MaxDomainQuota 102400
```

Creates a domain template with the name "MyDefaultDomainTemplate".
The maximum number of aliases and mailboxes will be set to 1000.
The domain wide total mailbox quota will be set to 100 GByte.

## PARAMETERS

### -DefaultMailboxQuota
The default mailbox quota limit in MiB.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 3072
Accept pipeline input: False
Accept wildcard characters: False
```

### -DkimKeySize
The DKIM key keysize.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 2096
Accept pipeline input: False
Accept wildcard characters: False
```

### -DkimSelector
The string to be used as DKIM selector.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Dkim
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable
Enable or disable the domain created by the template.

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

### -GlobalAddressList
Enable or disable the Global Address list for the domain created by the template.

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

### -Id
The ID value of the mailbox template to update.

```yaml
Type: Int64[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxDomainQuota
The domain wide total maximum mailbox quota limit in MiB.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 10240
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxMailboxQuota
The maximum mailbox quota limit in MiB.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 10240
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxNumberOfAliasesForDomain
The maximum number of aliases allowed in a domain.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 400
Accept pipeline input: False
Accept wildcard characters: False
```

### -MaxNumberOfMailboxesForDomain
The maximum number of mailboxes allowed in a domain.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: 10
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the domain template.

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

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: Hour
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimitValue
The rate limit value.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayAllRecipients
Enable or disable the relaying for all recipients for the domain created by the template.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayThisDomain
Enable or disable the relaying for the domain created by the template.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RelayUnknownOnly
Enable or disable the relaying for unknown recipients for the domain created by the template.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
One or more tags to will be assigned to a mailbox.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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

### Nothing
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainTemplate.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainTemplate.md)

