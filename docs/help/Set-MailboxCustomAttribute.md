---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxCustomAttribute.md
schema: 2.0.0
---

# Set-MHMailboxCustomAttribute

## SYNOPSIS
Updates custom attributes for one or more mailboxes.

## SYNTAX

```
Set-MHMailboxCustomAttribute [-Identity] <MailAddress[]> [-AttributeValuePair] <Hashtable>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates custom attributes for one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxCustomAttribute -Identity "user123@example.com" -AttributeValuePair @{VIPUser = "1"}
```

Adds the custom attribute name "VIPuser" with value "1" on the mailbox of "user123@example.com".

## PARAMETERS

### -AttributeValuePair
The key value pair to set as custom attribute.
Expects a hashtable.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which to update custom attributes.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases: Mailbox

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
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxCustomAttribute.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxCustomAttribute.md)

