---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteRecipientMap.md
schema: 2.0.0
---

# Set-MHAddressRewriteRecipientMap

## SYNOPSIS
Updates one or more address rewriting recipient maps.

## SYNTAX

```
Set-MHAddressRewriteRecipientMap [-Id] <Int32[]> [[-OriginalDomainOrMailAddress] <String>]
 [[-TargetDomainOrMailAddress] <String>] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates one or more address rewriting recipient maps.
Recipient maps are used to replace the destination address on a message before it is delivered.

## EXAMPLES

### EXAMPLE 1
```
Set-MHAddressRewriteRecipientMap -Id 4 -TargetDomainOrMailAddress example.com
```

Updates the address rewrite to the new target domain "example.com" for recipient map with id 4.

## PARAMETERS

### -Enable
Enable or disable the recipient map.

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

### -Id
The address rewrite recipient map id.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -OriginalDomainOrMailAddress
The domain or mail address for which to redirect mails.

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

### -TargetDomainOrMailAddress
The target domain or mail address.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
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

### System.Int32[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteRecipientMap.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteRecipientMap.md)

