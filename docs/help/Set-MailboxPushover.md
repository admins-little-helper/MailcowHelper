---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxPushover.md
schema: 2.0.0
---

# Set-MHMailboxPushover

## SYNOPSIS
Updates Pushover notification settings for one or more mailboxes.

## SYNTAX

```
Set-MHMailboxPushover [-Identity] <MailAddress[]> [-Token] <String> [-Key] <String> [[-Title] <String>]
 [[-Text] <String>] [[-SenderMailAddress] <MailAddress[]>] [[-Sound] <String>] [[-SenderRegex] <String>]
 [-EvaluateXPrio] [-OnlyXPrio] [-Enable] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
Updates Pushover notification settings for one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Set-MHMailboxPushover -Identity "user@example.com" -Token "APP_TOKEN" -Key "USER_KEY" -Enable
```

Enables Pushover notifications for the specified mailbox using the provided token and key.

### EXAMPLE 2
```
"user123@example.com", "user456@example.com" | Set-MHMailboxPushover -Enable -Sound "Magic"
```

Enables Pushover notifications for multiple mailboxes piped into the function and sets the
notification sound to "Magic".

### EXAMPLE 3
```
Set-MHMailboxPushover -Identity "alerts@example.com" -SenderRegex ".*@critical\.com" -EvaluateXPrio -Enable
```

Enables notifications only for senders matching the regex and escalates high-priority messages.

## PARAMETERS

### -Enable
Enables or disables Pushover notifications for the mailbox.

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

### -EvaluateXPrio
If specified, high-priority messages (X-Priority headers) are evaluated and escalated.

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
The mail address of the mailbox for which Pushover settings should be configured.

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

### -Key
The Pushover user or group key.

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

### -OnlyXPrio
If specified, only high-priority messages (X-Priority headers) are considered for notifications.

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

### -SenderMailAddress
One or more sender email addresses that should trigger a Pushover notification.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SenderRegex
Specifies a regular expression used to match sender addresses for triggering notifications.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sound
Specifies the notification sound to play.
Must be one of the predefined Pushover sound names.
Defaults to "Pushover".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Pushover
Accept pipeline input: False
Accept wildcard characters: False
```

### -Text
The notification body text sent via Pushover.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Title
The notification title sent via Pushover.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Token
The Pushover API application token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxPushover.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxPushover.md)

