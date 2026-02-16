class MailcowHelperArgumentCompleterAttribute : System.Management.Automation.ArgumentCompleterAttribute {
    <#
    .DESCRIPTION
        This custom attribute class implements auto-completion for some parameters used in several functions in the module,
        like mailbox usernames or domain names.

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/

    .LINK
        https://powershell.one/powershell-internals/attributes/custom-attributes#custom-argument-completer-attribute
    #>


    # Constructor calls base constructor and submits the completion code as scriptblock.
    # Added a mandatory positional argument $SearchAttribute with defines what values to get for autocompletion.
    # This argument is passed to a static method that creates the scriptblock that the base constructor wants:
    MailcowHelperArgumentCompleterAttribute([System.String[]] $SearchAttribute) : base([MailcowHelperArgumentCompleterAttribute]::_createScriptBlock($SearchAttribute)) {
        # Constructor has no own code.
    }

    # Create a static helper method that creates the scriptblock that the base constructor needs.
    # This is necessary to be able to access the argument(s) submitted to the constructor.
    hidden static [ScriptBlock] _createScriptBlock([System.String[]] $SearchAttribute) {
        $Scriptblock = {
            # Receive information about current state:
            param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)

            # Get module prefix.
            $ModulePrefix = (Get-Module -Name MailcowHelper).Prefix

            # Use variable "$ModulePrefix" to call the Get-MailcowHelperArgumentCompleterValue function.
            # This functions is a public function and gets the specified module prefix (or the default module prefix).
            # Therefore the function must be called by the prefixed name.
            # The function call uses the call operator "&"
            # See https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_operators?view=powershell-7.5#call-operator-

            switch ($SearchAttribute) {
                "Alias" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType Alias
                }
                "AliasDomain" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType AliasDomain
                }
                "Domain" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType Domain
                }
                "DomainAdmin" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType DomainAdmin
                }
                "DomainTemplate" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType DomainTemplate
                }
                "Mailbox" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType Mailbox
                }
                "MailboxTemplate" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType MailboxTemplate
                }
                "Resource" {
                    $SuggestValues += & "Get-$($ModulePrefix)MailcowHelperArgumentCompleterValue" -ItemType Resource
                }
                default {
                    # Should not reach this point. Do nothing.
                }
            }

            # Return all ArgumentCompleter values sorted and filtered by word to complete.
            $SuggestValues |
                Sort-Object |
                    Where-Object { $_ -like "$wordToComplete*" } |
                        ForEach-Object {
                            [System.Management.Automation.CompletionResult]::new($_, $_, "ParameterValue", $_)
                        }
        }.GetNewClosure()

        return $Scriptblock
    }
}