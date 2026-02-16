function Disconnect-Mailcow {
    <#
    .SYNOPSIS
        Clears the session variable holding information about a previously connected mailcow server and the custom ArgumentCompleter cache.

    .DESCRIPTION
        Clears the session variable holding information about a previously connected mailcow server and the custom ArgumentCompleter cache.

    .EXAMPLE
        Disconnect-MHMailcow

        Clears the session variable holding information about a previously connected mailcow server and the custom ArgumentCompleter cache.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Disconnect-Mailcow.md
    #>

    [CmdletBinding()]
    param()

    Initialize-MailcowHelperSession -ClearSession
    Write-MailcowHelperLog -Message "Session cleared."
}
