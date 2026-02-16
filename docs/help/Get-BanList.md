---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-BanList.md
schema: 2.0.0
---

# Get-MHBanList

## SYNOPSIS
Get ban list entries from the fail2ban service.

## SYNTAX

```
Get-MHBanList [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Get ban list entries from the fail2ban service.
This function is not using the mailcow rest API.
Instead it calls the fail2ban banlist URI which can be retried using the mailcow REST API.

## EXAMPLES

### EXAMPLE 1
```
Get-MHBanList
```

Returns ban list items from mailcow"s fail2ban service.

## PARAMETERS

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### System.String
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-BanList.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-BanList.md)

