function Enable-MailcowHelperArgumentCompleter {
    <#
    .SYNOPSIS
        Enables the MailcowHelper custom ArgumentCompleter for the specified item type.

    .DESCRIPTION
        Enables the MailcowHelper custom ArgumentCompleter for the specified item type.
        This module provides custom ArgumentCompleter for parameter expecting one of the following input types:
        Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

    .PARAMETER All
        Enables argument completer for all items

    .PARAMETER Alias
        Enables argument completer for Alias items.

    .PARAMETER AliasDomain
        Enables argument completer for AliasDomain items.

    .PARAMETER Domain
        Enables argument completer for Domain items.

    .PARAMETER DomainAdmin
        Enables argument completer for AliasDoDomainAdminmain items.

    .PARAMETER DomainTemplate
        Enables argument completer for DomainTemplate items.

    .PARAMETER Mailbox
        Enables argument completer for Mailbox items.

    .PARAMETER MailboxTemplate
        Enables argument completer for MailboxTemplate items.

    .PARAMETER Resource
        Enables argument completer for Resource items.

    .EXAMPLE
        Enable-MHMailcowHelperArgumentCompleter -All

        Enables custom ArgumentCompleter for all item types.

    .EXAMPLE
        Enable-MHMailcowHelperArgumentCompleter -Mailbox

        Enables custom ArgumentCompleter for mailbox item type.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Enable-MailcowHelperArgumentCompleter.md
    #>

    [CmdletBinding(DefaultParameterSetName = "All")]
    param(
        [Parameter(Position = 0, ParameterSetName = "All", Mandatory = $false, HelpMessage = "Enable argument completer for all items.")]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter(Position = 0, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for Alias items.")]
        [System.Management.Automation.SwitchParameter]
        $Alias,

        [Parameter(Position = 1, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for AliasDomain items.")]
        [System.Management.Automation.SwitchParameter]
        $AliasDomain,

        [Parameter(Position = 2, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for Domain items.")]
        [System.Management.Automation.SwitchParameter]
        $Domain,

        [Parameter(Position = 3, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for DomainAdmin items.")]
        [System.Management.Automation.SwitchParameter]
        $DomainAdmin,

        [Parameter(Position = 4, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for DomainTemplate items.")]
        [System.Management.Automation.SwitchParameter]
        $DomainTemplate,

        [Parameter(Position = 5, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for Mailbox items.")]
        [System.Management.Automation.SwitchParameter]
        $Mailbox,

        [Parameter(Position = 6, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for MailboxTemplate items.")]
        [System.Management.Automation.SwitchParameter]
        $MailboxTemplate,

        [Parameter(Position = 7, ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Enable argument completer for Resource items.")]
        [System.Management.Automation.SwitchParameter]
        $Resource
    )

    # Enable custom ArgumentCompleter for itemtype "Alias".
    if ($All.IsPresent -or $Alias.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "Alias") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [Alias]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "Alias"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [Alias]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "AliasDomain".
    if ($All.IsPresent -or $AliasDomain.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "AliasDomain") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [AliasDomain]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "AliasDomain"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [AliasDomain]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "Domain".
    if ($All.IsPresent -or $Domain.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "Domain") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [Domain]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "Domain"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [Domain]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "DomainAdmin".
    if ($All.IsPresent -or $DomainAdmin.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "DomainAdmin") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [DomainAdmin]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "DomainAdmin"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [DomainAdmin]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "DomainTemplate".
    if ($All.IsPresent -or $DomainTemplate.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "DomainTemplate") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [DomainTemplate]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "DomainTemplate"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [DomainTemplate]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "Mailbox".
    if ($All.IsPresent -or $Mailbox.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "Mailbox") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [Mailbox]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "Mailbox"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [Mailbox]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "MailboxTemplate".
    if ($All.IsPresent -or $MailboxTemplate.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "MailboxTemplate") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [MailboxTemplate]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "MailboxTemplate"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [MailboxTemplate]."
        }
    }

    # Enable custom ArgumentCompleter for itemtype "Resource".
    if ($All.IsPresent -or $Resource.IsPresent) {
        if ($Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor -notcontains "Resource") {
            Write-MailcowHelperLog -Message "Enable ArgumentCompleter for [Resource]."
            [Array]$Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor += "Resource"
        }
        else {
            Write-MailcowHelperLog -Message "ArgumentCompleter already enabled for [Resource]."
        }
    }
}