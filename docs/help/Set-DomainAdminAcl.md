---
external help file: MailcowHelper-help.xml
Module Name: MailcowHelper
online version: https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdminAcl.md
schema: 2.0.0
---

# Set-MHDomainAdminAcl

## SYNOPSIS
Updates one or more domain admin ACL (Access Control List) permissions.

## SYNTAX

### All
```
Set-MHDomainAdminAcl -Identity <String[]> [-All] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Individual
```
Set-MHDomainAdminAcl -Identity <String[]> [-SyncJob] [-Quarantine] [-LoginAs] [-SogoAccess] [-AppPassword]
 [-BccMap] [-Pushover] [-Filter] [-RateLimit] [-SpamPolicy] [-ExtendedSenderAcl] [-UnlimitedQuota]
 [-ProtocolAccess] [-SmtpIpAccess] [-AliasDomains] [-DomainDescription] [-ChangeRelayhostForDomain]
 [-ChangeRelayhostForMailbox] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Updates one or more domain admin ACL (Access Control List) permissions.

## EXAMPLES

### EXAMPLE 1
```
Set-MHDomainAdminAcl -Username "admin1" -SyncJob -Quarantine -LoginAs
```

Enables SyncJob, Quarantine, and LoginAs ACL permissions for the domain admin "admin1".

### EXAMPLE 2
```
"admin1","admin2" | Set-MHDomainAdminAcl -All
```

Enables all ACL permissions for multiple domain admins piped into the function.

## PARAMETERS

### -AliasDomains
Allows adding alias domains.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -All
Enables all ACL permissions for the specified domain admin(s).

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppPassword
Allows management of app passwords.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BccMap
Allows management of BCC maps.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChangeRelayhostForDomain
Allows changing the relay host for a domain.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ChangeRelayhostForMailbox
Allows changing the relay host for a mailbox.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DomainDescription
Allows modifying the domain description.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExtendedSenderAcl
Allows extending sender ACLs with external addresses.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Allows management of filters.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Identity
{{ Fill Identity Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -LoginAs
Allows login as a mailbox user.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
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

### -ProtocolAccess
Allows changing protocol access settings.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Pushover
Allows management of Pushover settings.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Quarantine
Allows management of quarantine settings.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -RateLimit
Allows management of rate limits.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmtpIpAccess
Allows modifying allowed SMTP hosts.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SogoAccess
Allows management of SOGo access.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpamPolicy
Allows management of spam policy settings.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SyncJob
Allows management of sync job settings.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -UnlimitedQuota
Allows setting unlimited mailbox quota.

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
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

[https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdminAcl.md](https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdminAcl.md)

