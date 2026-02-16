---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AddressRewriteBccMap.md
schema: 2.0.0
---

# New-MHAddressRewriteBccMap

## SYNOPSIS
Add a new BCC map.

## SYNTAX

```
New-MHAddressRewriteBccMap [-Identity] <String[]> [-BccDestination] <MailAddress> [[-BccType] <String>]
 [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Add a new BCC map.
BCC maps are used to silently forward copies of all messages to another address.
A recipient map type entry is used, when the local destination acts as recipient of a mail.
Sender maps conform to the same principle.
The local destination will not be informed about a failed delivery.

## EXAMPLES

### EXAMPLE 1
```
New-MHAddressRewriteBccMap -Identity "user1@example.com" -BccDestination "user2@example.com" -BccType "Recipient"
```

This adds a BCC map so every mail sent to mailbox "user1@example.com" is BCCed to "user2@example.com".

### EXAMPLE 2
```
New-MHAddressRewriteBccMap -Identity "sub.example.com" -BccDestination "admin@example.com" -BccType "Recipient"
```

This adds a BCC map so every mail sent to domain "sub.example.com" is BCCed to "admin@example.com".

### EXAMPLE 3
```
New-MHAddressRewriteBccMap -Identity "support@example.com" -BccDestination "suppport-manager@example.com" -BccType "Sender"
```

This adds a BCC map so every mail sent from mailbox "support@example.com" is BCCed to "suppport-manager@example.com".

## PARAMETERS

### -BccDestination
The bcc target.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases: Target

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BccType
Either "Sender" or "Recipient".
"Sender" means, that the rule will be applied for mails sent from the mail address or domain specified by the "Identity" parameter.
"Recipient" means, that the rule will be applied for mails sent to the mail address or domain specified by the "Identity" parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases: Type

Required: False
Position: 3
Default value: Sender
Accept pipeline input: False
Accept wildcard characters: False
```

### -Enable
By default new BCC maps are always enabled.
To add a new BCC map in disabled state, specify "-Enable:$false".

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address or the name of the domain for which to add a BCC map.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Mailbox, Domain, LocalDestination

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

### System.String[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AddressRewriteBccMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AddressRewriteBccMap.md)

