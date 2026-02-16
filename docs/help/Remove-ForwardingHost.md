---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-ForwardingHost.md
schema: 2.0.0
---

# Remove-MHForwardingHost

## SYNOPSIS
Delete one or more forwarding host from the mailcow configuration.

## SYNTAX

### Hostname (Default)
```
Remove-MHForwardingHost [-Hostname] <String[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### IpAddress
```
Remove-MHForwardingHost [-IpAddress] <IPNetwork[]> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Delete one or more forwarding host from the mailcow configuration.

## EXAMPLES

### EXAMPLE 1
```
Remove-MHForwardingHost -Hostname mail.example.com
```

This will delete all entries found for the forwarding host mail.example.com.

### EXAMPLE 2
```
Remove-MHForwardingHost IpAddress 1.2.3.4
```

This will delete the forwarding host with ip address 1.2.3.4.

## PARAMETERS

### -Hostname
The hostname of the forwarding host to delete.

```yaml
Type: String[]
Parameter Sets: Hostname
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -IpAddress
IP address of a forwarding host to delete.

```yaml
Type: IPNetwork[]
Parameter Sets: IpAddress
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

### System.String[]
### System.Net.IPNetwork[]
## OUTPUTS

### PSCustomObject
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-ForwardingHost.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-ForwardingHost.md)

