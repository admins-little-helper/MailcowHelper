---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Mailbox.md
schema: 2.0.0
---

# Get-MHMailbox

## SYNOPSIS
Return information about one or more mailboxes.

## SYNTAX

### Identity (Default)
```
Get-MHMailbox [[-Identity] <MailAddress[]>] [[-Tag] <String[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Domain
```
Get-MHMailbox [[-Domain] <String[]>] [[-Tag] <String[]>] [-Raw] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Return information about one or more mailboxes.

## EXAMPLES

### EXAMPLE 1
```
Get-MHMailbox
```

Return information for all mailboxes on the mailcow server.

### EXAMPLE 2
```
Get-MHMailbox -Domain "example.com"
```

Returns mailbox information for all mailboxes in domain "example.com".

### EXAMPLE 3
```
Get-MHMailbox -Tag "MyTag"
```

Returns mailbox information for all mailboxes tagged with "MyTag"

### EXAMPLE 4
```
Get-MHMailbox -Domain "example.com" -Tag "MyTag"
```

Returns mailbox information for all mailboxes tagged with "MyTag" in domain "example.com"

## PARAMETERS

### -Domain
The name of the domain for which to get mailbox information.

```yaml
Type: String[]
Parameter Sets: Domain
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -Identity
The mail address of the mailbox for which to get information.
If omitted, all mailboxes are returned.

```yaml
Type: MailAddress[]
Parameter Sets: Identity
Aliases: Mailbox

Required: False
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

### -Raw
Return the result in raw format as returned by Invoke-WebRequest.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tag
A tag to filter the result on.
This is only relevant if parameter "Identity" is not specified so to return all mailboxes.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Mailbox.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Mailbox.md)

