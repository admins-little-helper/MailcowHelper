---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
schema: 2.0.0
---

# New-MHAppPassword

## SYNOPSIS
Add a new application-specific password for a mailbox user.

## SYNTAX

```
New-MHAppPassword [-Identity] <MailAddress[]> [-Name] <String> [-Password] <SecureString>
 [[-Protocol] <String[]>] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Add a new application-specific password for a mailbox user.

## EXAMPLES

### EXAMPLE 1
```
New-MHAppPassword -Identity "user1@example.com" -Name "New name for app password" -Protcol "EAS"
```

Add an application-specific password for "user1@example.com" that can be used for Active Sync connections.

## PARAMETERS

### -Enable
Enable or disable the app password.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which to add an app password.

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

### -Name
A name for the app password.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AppName

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password to set.

```yaml
Type: SecureString
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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

### -Protocol
The protocol(s) for which the app password can be used.
One or more of the following values:
IMAP, DAV, SMTP, EAS, POP3, Sieve

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md)

