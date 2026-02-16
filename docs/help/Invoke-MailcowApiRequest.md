---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Invoke-MailcowApiRequest.md
schema: 2.0.0
---

# Invoke-MHMailcowApiRequest

## SYNOPSIS
Wrapper function for "Invoke-WebRequest" used to call the mailcow API.

## SYNTAX

```
Invoke-MHMailcowApiRequest [-UriPath] <String> [[-Method] <String>] [[-Body] <Object>] [-Insecure]
 [-SkipCertificateCheck] [-Raw] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
Wrapper function for "Invoke-WebRequest" used to call the mailcow API.
This function simplifies calling the API and is used by functions in this module.

## EXAMPLES

### EXAMPLE 1
```
Invoke-MHMailcowApiRequest -UriPath "get/status/version"
```

Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version (requires to run "Connect-Mailcow" first).

### EXAMPLE 2
```
Invoke-MHMailcowApiRequest -UriPath "get/status/version" -Raw
```

Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version as JSON string (requires to run "Connect-Mailcow" first).

## PARAMETERS

### -Body
The request body.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Insecure
If specified, use http instead of https.

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

### -Method
Specify the HTTP method to use (GET or POST).

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: GET
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

### -Raw
If specified, return the resulting content of the web request in raw format as JSON string instead of a PSCustomObject.

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

### -SkipCertificateCheck
If specified, ignore certificate.

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

### -UriPath
Specify the path appended to the base URI.
The base URI is build from the mailcow server name specified in "Connect-Mailcow", the string "/api/"
the API version specified in "Connect-Mailcow" and the UriPath specified here.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### Nothing
## OUTPUTS

### PSCustomObject,
### System.String
## NOTES
Author:     Dieter Koch
Email:      diko@admins-little-helper.de

## RELATED LINKS

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Invoke-MailcowApiRequest.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Invoke-MailcowApiRequest.md)

