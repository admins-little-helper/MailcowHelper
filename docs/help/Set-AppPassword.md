---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
schema: 2.0.0
---

# Set-MHAppPassword

## SYNOPSIS
Updates one or more users application-specific password configurations.

## SYNTAX

```
Set-MHAppPassword [-Id] <Int32[]> [-Mailbox] <MailAddress> [[-Name] <String>] [[-Password] <SecureString>]
 [[-Protocol] <String[]>] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates one or more users application-specific password configurations.

To update an app password configuration, the app password id and the mailbox address
must be specified.

## EXAMPLES

### EXAMPLE 1
```
Set-MHAppPassword -Identity 7 -Name "New name for app password" -Protcol "EAS"
```

Change the name for app password with ID 7 to "New name for app passwrord" and change the protocol to allow only "EAS".

## PARAMETERS

### -Enable
Enable or disable the app password.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The app password id.

```yaml
Type: Int32[]
Parameter Sets: (All)
Aliases: AppPasswordId

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Mailbox
The mail address of the mailbox for which to update the app password.

```yaml
Type: MailAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
A name for the app password.

```yaml
Type: String
Parameter Sets: (All)
Aliases: AppName

Required: False
Position: 3
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

Required: False
Position: 4
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
Position: 5
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md)

