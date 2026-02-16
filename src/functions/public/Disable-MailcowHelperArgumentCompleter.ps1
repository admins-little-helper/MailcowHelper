function Disable-MailcowHelperArgumentCompleter {
    <#
    .SYNOPSIS
        Disables the MailcowHelper custom ArgumentCompleter for the specified item type.

    .DESCRIPTION
        Disables the MailcowHelper custom ArgumentCompleter for the specified item type.
        This module provides custom ArgumentCompleter for parameter expecting one of the following input types:
        Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

    .PARAMETER All
        Disable argument completer for all items

    .PARAMETER Alias
        Disable argument completer for Alias items.

    .PARAMETER AliasDomain
        Disable argument completer for AliasDomain items.

    .PARAMETER Domain
        Disable argument completer for Domain items.

    .PARAMETER DomainAdmin
        Disable argument completer for AliasDoDomainAdminmain items.

    .PARAMETER DomainTemplate
        Disable argument completer for DomainTemplate items.

    .PARAMETER Mailbox
        Disable argument completer for Mailbox items.

    .PARAMETER MailboxTemplate
        Disable argument completer for MailboxTemplate items.

    .PARAMETER Resource
        Disable argument completer for Resource items.

    .EXAMPLE
        Disable-MHMailcowHelperArgumentCompleter -All

        Disables custom ArgumentCompleter for all item types.

    .EXAMPLE
        Disable-MHMailcowHelperArgumentCompleter -Mailbox

        Disables custom ArgumentCompleter for mailbox item type.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Disable-MailcowHelperArgumentCompleter.md
    #>

    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(ParameterSetName = "All", Position = 0, Mandatory = $false, HelpMessage = "Disable argument completer for all items.")]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter(ParameterSetName = "Individual", Position = 0, Mandatory = $false, HelpMessage = "Disable argument completer for Alias items.")]
        [System.Management.Automation.SwitchParameter]
        $Alias,

        [Parameter(ParameterSetName = "Individual", Position = 1, Mandatory = $false, HelpMessage = "Disable argument completer for AliasDomain items.")]
        [System.Management.Automation.SwitchParameter]
        $AliasDomain,

        [Parameter(ParameterSetName = "Individual", Position = 2, Mandatory = $false, HelpMessage = "Disable argument completer for Domain items.")]
        [System.Management.Automation.SwitchParameter]
        $Domain,

        [Parameter(ParameterSetName = "Individual", Position = 3, Mandatory = $false, HelpMessage = "Disable argument completer for DomainAdmin items.")]
        [System.Management.Automation.SwitchParameter]
        $DomainAdmin,

        [Parameter(ParameterSetName = "Individual", Position = 4, Mandatory = $false, HelpMessage = "Disable argument completer for DomainTemplate items.")]
        [System.Management.Automation.SwitchParameter]
        $DomainTemplate,

        [Parameter(ParameterSetName = "Individual", Position = 5, Mandatory = $false, HelpMessage = "Disable argument completer for Mailbox items.")]
        [System.Management.Automation.SwitchParameter]
        $Mailbox,

        [Parameter(ParameterSetName = "Individual", Position = 6, Mandatory = $false, HelpMessage = "Disable argument completer for MailboxTemplate items.")]
        [System.Management.Automation.SwitchParameter]
        $MailboxTemplate,

        [Parameter(ParameterSetName = "Individual", Position = 7, Mandatory = $false, HelpMessage = "Disable argument completer for Resource items.")]
        [System.Management.Automation.SwitchParameter]
        $Resource
    )

    # Disable custom ArgumentCompleter for itemtype "Alias".
    if ($All.IsPresent -or $Alias.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "Alias") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [Alias]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "Alias"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "AliasDomain".
    if ($All.IsPresent -or $AliasDomain.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "AliasDomain") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [AliasDomain]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "AliasDomain"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "Domain".
    if ($All.IsPresent -or $Domain.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "Domain") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [Domain]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "Domain"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "DomainAdmin".
    if ($All.IsPresent -or $DomainAdmin.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "DomainAdmin") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [DomainAdmin]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "DomainAdmin"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "DomainTemplate".
    if ($All.IsPresent -or $DomainTemplate.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "DomainTemplate") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [DomainTemplate]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "DomainTemplate"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "Mailbox".
    if ($All.IsPresent -or $Mailbox.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "Mailbox") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [Mailbox]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "Mailbox"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "MailboxTemplate".
    if ($All.IsPresent -or $MailboxTemplate.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "MailboxTemplate") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [MailboxTemplate]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "MailboxTemplate"
            }
        }
    }

    # Disable custom ArgumentCompleter for itemtype "Resource".
    if ($All.IsPresent -or $Resource.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -contains "Resource") {
            Write-MailcowHelperLog -Message "Disable ArgumentCompleter for [Resource]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor | Where-Object {
                $_ -ne "Resource"
            }
        }
    }
}