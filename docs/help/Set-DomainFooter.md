---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainFooter.md
schema: 2.0.0
---

# Set-MHDomainFooter

## SYNOPSIS
Update the footer of one or more domains.

## SYNTAX

```
Set-MHDomainFooter [-Identity] <String[]> [[-HtmlFooter] <String>] [[-PlainFooter] <String>]
 [[-ExcludeMailbox] <MailAddress[]>] [-SkipFooterForReplies] [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Update the footer of one or more domains.

## EXAMPLES

### EXAMPLE 1
```
Set-MHDomainFooter -Identity "example.com" -HtmlFooter (Get-Content -Path "C:\Temp\example-com-footer.html") -SkipFooterForReplies
```

This will read the content of the html file "C:\Temp\example-com-footer.html" and set it as footer for the domain "example.com"
The footer will not be added on reply messages.

## PARAMETERS

### -ExcludeMailbox
One or more m address(es) to be excluded from the domain wide footer.

```yaml
Type: MailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HtmlFooter
Footer in HTML format.

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

### -Identity
The name of the domain for which to update the footer.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Domain

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -PlainFooter
Footer in plain text format.

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

### -SkipFooterForReplies
Don't add footer on reply messages.

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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainFooter.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainFooter.md)

