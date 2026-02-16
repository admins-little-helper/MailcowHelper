---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasTimeLimited.md
schema: 2.0.0
---

# New-MHAliasTimeLimited

## SYNOPSIS
Adds a time-limited alias (spamalias) to a mailbox.

## SYNTAX

### ExpireIn (Default)
```
New-MHAliasTimeLimited [-Identity] <MailAddress[]> [[-ForAliasDomain] <String>] [-Description] <String>
 [[-ExpireIn] <String>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Permanent
```
New-MHAliasTimeLimited [-Identity] <MailAddress[]> [[-ForAliasDomain] <String>] [-Description] <String>
 [-Permanent] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### ExpireInHours
```
New-MHAliasTimeLimited [-Identity] <MailAddress[]> [[-ForAliasDomain] <String>] [-Description] <String>
 [[-ExpireInHours] <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Adds a time-limited alias (spamalias) to a mailbox.

## EXAMPLES

### EXAMPLE 1
```
New-MHAliasTimeLimited -Identity "mailbox@example.com" -Permanent
```

This will add a new time-limited alias for the mailbox "mailbox@example.org".
The new alias will not expire.

### EXAMPLE 2
```
New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"
```

This will add a new time-limited alias for the mailbox "mailbox@example.org".
The alias will by default be valid for/expire in 1 year.

### EXAMPLE 3
```
New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"
$NewAliasAddress = (Get-MHAliasTimeLimited -Identity "mailbox@example.com" | Sort-Object -Property WhenCreated | Select-Object -Last 1).Address
$NewAliasAddress | Set-MHAliasTimeLimited -ExpireIn 1Week
```

This will add a new time-limited alias for the mailbox "mailbox@example.org".
The alias will by default be valid for/expire in 1 year.
Then the newest alias address is stored in $NewAliasAddress" and the expiration is set to 1 week.

## PARAMETERS

### -Description
Description for the time-limited alias.
The description can only be set during creation.
It can not be updated afterwards (neither in the WebGui nor via the API).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireIn
Set a predefined time period.
Allowed values are:
1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

```yaml
Type: String
Parameter Sets: ExpireIn
Aliases:

Required: False
Position: 4
Default value: 1Year
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExpireInHours
Set a custom value as number of hours from now.
The valid range is 1 to 105200, which is between 1 hour and about 12 years.

```yaml
Type: Int32
Parameter Sets: ExpireInHours
Aliases:

Required: False
Position: 4
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForAliasDomain
The alias domain in which to create a new time-limited alias.
This must be an alias domain that is valid for the specified user"s primary domain.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AliasDomain, Domain

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which to create a time-limited alias.

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

### -Permanent
If specified, the time-limit alias will be set to never expire.
Otherwise any new time-limited alias will be set to expire in 1 year.
You can use "Set-AliasTimeLimited" to change the the validity period afterwards.

```yaml
Type: SwitchParameter
Parameter Sets: Permanent
Aliases:

Required: False
Position: 4
Default value: False
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasTimeLimited.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasTimeLimited.md)

