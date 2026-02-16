function Get-MailcowHelperArgumentCompleterValue {
    <#
    .SYNOPSIS
        Get values for the specified argument completer.

    .DESCRIPTION
        Get values for the specified argument completer.
        This function is used internally in the module to enable argument completion
        on function parameters expecting one of the following input values:
        Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

    .PARAMETER ItemType
        One of the following types:
        Alias, AliasDomain, Domain, DomainAdmin, Mailbox, Resource

    .EXAMPLE
        Get-MHMailcowHelperArgumentCompleterValue ItemType Domain

        Returns all domain values available for argument completion.

    .INPUTS
        Nothing

    .OUTPUTS
        System.String

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperArgumentCompleterValue.md
    #>

    [OutputType([System.String])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("Alias", "AliasDomain", "Domain", "DomainAdmin", "DomainTemplate", "Mailbox", "MailboxTemplate", "Resource")]
        [System.String]
        $ItemType
    )

    # Get the value from the module session variable.
    $ReturnValue = $Script:MailcowHelperSession.ArgumentCompleter.$ItemType
    $ReturnValue
}