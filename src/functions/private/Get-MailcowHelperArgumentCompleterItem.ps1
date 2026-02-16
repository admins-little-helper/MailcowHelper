function Get-MailcowHelperArgumentCompleterItem {
    <#
    .SYNOPSIS
        Reads and caches values for the custom ArgumentCompleter items.

    .DESCRIPTION
        Reads and caches values for the custom ArgumentCompleter items.

    .PARAMETER ItemType
        Specify the type of the item to read and cache.

    .EXAMPLE
        Get-MailcowHelperArgumentCompleterItem -ItemType "Mailbox"

        Reads all mailboxes from mailcow and saves the username/email address value in the session variable.

    .INPUTS
        Nothing

    .OUTPUTS
        System.String[]

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperArgumentCompleterItem.md
    #>

    [OutputType([System.String[]])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The type of ArgumentCompleter items to return.")]
        [ValidateSet("Alias", "AliasDomain", "Domain", "DomainAdmin", "DomainTemplate", "Mailbox", "MailboxTemplate", "Resource")]
        [System.String]
        $ItemType
    )

    switch ($ItemType) {
        "Alias" {
            $ReturnValue = Get-AliasMail -Raw | ForEach-Object { $_.address }
            break
        }
        "AliasDomain" {
            $ReturnValue = Get-AliasDomain -Identity "all" -Raw | ForEach-Object { $_.alias_domain }
            break
        }
        "Domain" {
            $ReturnValue = Get-Domain -Raw -Domain "all" | ForEach-Object { $_.domain_name }
            break
        }
        "DomainAdmin" {
            $ReturnValue = Get-DomainAdmin -Raw | ForEach-Object { $_.username }
            break
        }
        "DomainTemplate" {
            $ReturnValue = Get-DomainTemplate -Raw | ForEach-Object { $_.template }
            break
        }
        "Mailbox" {
            $ReturnValue = Get-Mailbox -Raw | ForEach-Object { $_.username }
            break
        }
        "MailboxTemplate" {
            $ReturnValue = Get-MailboxTemplate -Raw | ForEach-Object { $_.template }
            break
        }
        "Resource" {
            $ReturnValue = Get-Resource -Raw | ForEach-Object { $_.name }
            break
        }
        default {
            # Should not reach this point.
        }
    }

    # Return the values.
    $ReturnValue
}
