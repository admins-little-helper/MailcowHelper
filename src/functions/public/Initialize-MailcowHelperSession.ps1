function Initialize-MailcowHelperSession {
    <#
    .SYNOPSIS
        Initializes a session to a mailcow server using the MailcowHelper module.

    .DESCRIPTION
        Initializes a session to a mailcow server using the MailcowHelper module.
        This is used to prepare the argument completers used for several functions in this module.

    .PARAMETER DisableArgumentCompleter
        Disables all argument completers.
        Argument completers for individual item types can also be disabled or enabled using the
        "Enable-MailcowHelperArgumentCompleter" and "Disable-MailcowHelperArgumentCompleter" functions.

    .PARAMETER ClearSession
        Clears the module session variable and therefore removes all stored settings from memory.

    .EXAMPLE
        Initialize-MHMailcowHelperSession

        Prepares the argument completers for all item types in the background.

    .EXAMPLE
        Initialize-MHMailcowHelperSession -DisableArgumentCompleter

        Skips preparing all argument completers.

    .EXAMPLE
        Initialize-MHMailcowHelperSession -ClearSession

        Cleares the module session variable and therefore removes all in-memory settings.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Initialize-MailcowHelperSession.md
    #>

    [CmdletBinding(DefaultParameterSetName = "Connect")]
    param(
        [Parameter(Position = 0, ParameterSetName = "Connect", Mandatory = $false, HelpMessage = "Disables all argument completers.")]
        [System.Management.Automation.SwitchParameter]
        $DisableArgumentCompleter,

        [Parameter(Position = 0, ParameterSetName = "Disconnect", Mandatory = $false, HelpMessage = "Clears the module session variable and therefore removes all stored settings from memory.")]
        [System.Management.Automation.SwitchParameter]
        $ClearSession
    )

    switch ($PSCmdlet.ParameterSetName) {
        "Connect" {
            if ($DisableArgumentCompleter.IsPresent) {
                # Disable ArgumentCompleter for all items.
                $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor = [Array]@()
            }

            # If ArgumentCompleter is not completely disabled, try to get the item values for all the enabled ArgumentCompleter items and store it in the session variable.
            foreach ($ArgumentCompleterItem in $Script:MailcowHelperSession.ArgumentCompleterConfig.EnableFor) {
                $Script:MailcowHelperSession.ArgumentCompleter.$ArgumentCompleterItem = Get-MailcowHelperArgumentCompleterItem -ItemType $ArgumentCompleterItem
            }

            break
        }
        "Disconnect" {
            if ($ClearSession.IsPresent) {
                # Clear all saved settings.
                $Script:MailcowHelperSession.ConnectParams = @{}
                $Script:MailcowHelperSession.ArgumentCompleterConfig = @{}
                $Script:MailcowHelperSession.ArgumentCompleter = @{}
            }

            break
        }
        default {
            # Should never reach this point.
            break
        }
    }
}
