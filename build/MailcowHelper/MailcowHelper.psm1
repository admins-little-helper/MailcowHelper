
# Adding Module variable, aka Pseudo-Namespace
# More information can be found here: https://thedavecarroll.com/powershell/how-i-implement-module-variables/
$MailcowHelper = [ordered]@{
    ConnectParams           = @{}
    ArgumentCompleterConfig = @{
        EnableFor = @(
            "Alias",
            "AliasDomain",
            "Domain",
            "DomainTemplate",
            "DomainAdmin",
            "Mailbox",
            "MailboxTemplate",
            "Resource"
        )
    }
    ArgumentCompleter       = @{}
}
New-Variable -Name MailcowHelperSession -Value $MailcowHelper -Scope Script -Force


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

enum MailcowHelperMailboxActiveState {
    <#
    .DESCRIPTION
        Custom enum for mailcow mailbox active state values.

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/
    #>

    Inactive = 0
    Active = 1
    DisallowLogin = 2
}

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

function Write-MailcowHelperLog {
    [CmdletBinding()]
    <#
    .SYNOPSIS
        Adds the current date/time and the calling function"s name to the specified message and writes it to the specified stream.

    .DESCRIPTION
        Adds the current date/time and the calling function"s name to the specified message and writes it to the specified stream.

    .PARAMETER Message
        The message to write.

    .PARAMETER Level
        Specify to which stream the message should be written.

    .EXAMPLE
        Write-MailcowHelperLog -Message "This works!" -Level Information

        Write the string "This works!" to the information stream.

    .EXAMPLE
        Write-MailcowHelperLog -Message "You have been warned!" -Level Warning

        Write the string "You have been warned!" to the warning stream.

    .INPUTS
        Nothing

    .OUTPUTS
        [System.String[]]

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Write-MailcowHelperLog.md
    #>

    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The message to write.")]
        [System.String]
        $Message,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Specify to which stream the message should be written.")]
        [ValidateSet("Debug", "Verbose", "Information", "Warning", "Error")]
        [System.String]
        $Level = "Verbose"
    )

    # Prepand date/time and calling function name.
    $DateTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss.ffff"
    $Message = "[$DateTime] [$(((Get-PSCallStack)[1]).Command)] $Message"

    switch ($Level) {
        "Debug" {
            Write-Debug -Message $Message
            break
        }
        "Verbose" {
            Write-Verbose -Message $Message
            break
        }
        "Information" {
            Write-Information -MessageData $Message -InformationAction Continue
            break
        }
        "Warning" {
            Write-Warning -Message $Message
            break
        }
        "Error" {
            Write-Error -Message $Message
            break
        }
        default {
            #tbd
        }
    }
}

function Clear-EasCache {
    <#
    .SYNOPSIS
        Clear the EAS (Exchange Active Sync) cache for one or more mailboxes.

    .DESCRIPTION
        Clear the EAS (Exchange Active Sync) cache for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to clear the EAS cache.

    .EXAMPLE
        Clear-MHEasCache -Identity "user1@example.com"

        Clears the EAS cache for "user1@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Clear-EasCache.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to clear the EAS cache.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/eas_cache"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("mailcow EAS cache for [$($IdentityItem.Address)]", "Clear")) {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Clearing EAS cache for mailbox" -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Clear-Queue {
    <#
    .SYNOPSIS
        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .DESCRIPTION
        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .EXAMPLE
        Clear-MHQueue

        Flush the current mail queue. This will try to deliver all mails currently in the queue.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Clear-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param()

    # Prepare the base Uri path.
    $UriPath = "edit/mailq"

    # Prepare the request body.
    $Body = @{
        action = "flush"
    }

    if ($PSCmdlet.ShouldProcess("mailcow mail queue", "Flush")) {
        Write-MailcowHelperLog -Message "Flushing mailcow mail queue. Try to deliver all mails currently in the queue." -Level Information

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

        # Return the result.
        $Result
    }

}

function Connect-Mailcow {
    <#
    .SYNOPSIS
        Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

    .DESCRIPTION
        Connects to the specified mailcow server using the specified API key, or loads previously saved settings.

        This ensures that the specified API key is valid and stored in memory for sub-sequent function calls.
        To clear the connection settings from memory, run "Disconnect-Mailcow".

    .PARAMETER LoadConfig
        Loads the config from a file.

    .PARAMETER Path
        The path to the config file to load.

    .PARAMETER Computername
        The mailcow server name to connect to.

    .PARAMETER ApiKey
        The API key to use for authentication.

    .PARAMETER ApiVersion
        The API version to use.

    .PARAMETER DisableArgumentCompleter
        Disable the MailcowHelper custom ArgumentCompleter completly.

    .PARAMETER Insecure
        Use http instead of https.

    .PARAMETER SkipCertificateCheck
        Skips certificate validation checks. This includes all validations such as expiration, revocation, trusted root authority, etc.

    .EXAMPLE
        Connect-MHMailcow -Computername mymailcow.example.com -ApiKey 12345-67890-ABCDE-FGHIJ-KLMNO

        Connect to server mymailcow.example.com using the specified API key. If the connection is successful, the mailcow server version is returned.

    .EXAMPLE
        Connect-MHMailcow -LoadConfig

        Loads the config from the default config file ($env:USERPROFILE\.MailcowHelper.json on Windows,
        env:HOME\.MailcowHelper.json on Unix) and uses the connection settings loaded.
        If the connection is successful, the mailcow server version is returned.

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Connect-Mailcow.md
    #>

    [CmdletBinding(DefaultParameterSetName = "ManualConfig")]
    param(
        [Parameter(ParameterSetName = "AutoConfig", Position = 0, Mandatory = $false, HelpMessage = "Loads the config from a file.")]
        [System.Management.Automation.SwitchParameter]
        $LoadConfig,

        [Parameter(ParameterSetName = "AutoConfig", Position = 1, Mandatory = $false, HelpMessage = "The path to the config file to load.")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path,

        [Parameter(ParameterSetName = "ManualConfig", Position = 0, Mandatory = $true, HelpMessage = "The mailcow server name to connect to.")]
        [Alias("Server", "Hostname")]
        [System.String]
        $Computername,

        [Parameter(ParameterSetName = "ManualConfig", Position = 1, Mandatory = $true, HelpMessage = "The API key to use for authentication.")]
        [System.String]
        $ApiKey,

        [Parameter(ParameterSetName = "ManualConfig", Position = 2, Mandatory = $false, HelpMessage = "The API version to use.")]
        [ValidateSet("v1")]
        [System.String]
        $ApiVersion = "v1",

        [Parameter(ParameterSetName = "ManualConfig", Position = 3, Mandatory = $false, HelpMessage = "Disable the MailcowHelper custom ArgumentCompleter completly.")]
        [Parameter(ParameterSetName = "AutoConfig", Position = 2, Mandatory = $false, HelpMessage = "Disable the MailcowHelper custom ArgumentCompleter completly.")]
        [System.Management.Automation.SwitchParameter]
        $DisableArgumentCompleter,

        [Parameter(ParameterSetName = "ManualConfig", Position = 4, Mandatory = $false, HelpMessage = "Use http instead of https.")]
        [System.Management.Automation.SwitchParameter]
        $Insecure,

        [Parameter(ParameterSetName = "ManualConfig", Position = 5, Mandatory = $false, HelpMessage = "Skips certificate validation checks.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCertificateCheck
    )

    if ($LoadConfig.IsPresent) {
        if ($Path -and (Test-Path -Path $Path)) {
            # Try to load previously saved config from the specified path.
            Get-MailcowHelperConfig -Path $Path
        }
        else {
            # Load config from default config file.
            Get-MailcowHelperConfig
        }

        # If connection parameters are there, try to use it.
        if ($Script:MailcowHelperSession.ConnectParams) {
            if ($Script:MailcowHelperSession.ConnectParams.Computername) {
                $Computername = $Script:MailcowHelperSession.ConnectParams.Computername
            }
            if ($Script:MailcowHelperSession.ConnectParams.ApiVersion) {
                $ApiVersion = $Script:MailcowHelperSession.ConnectParams.ApiVersion
            }
            if ($Script:MailcowHelperSession.ConnectParams.ApiKey) {
                $ApiKey = $Script:MailcowHelperSession.ConnectParams.Insecure
            }
            if ($Script:MailcowHelperSession.ConnectParams.Insecure) {
                # Use http and show a warning about the insecure connection.
                Write-MailcowHelperLog -Message "Insecure connection type enabled!" -Level Warning
                $Insecure = $Script:MailcowHelperSession.ConnectParams.ApiKey
            }
            if ($Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck) {
                # Skip certificate checks and show a warning about it.
                Write-MailcowHelperLog -Message "SkipCertificateCheck set!" -Level Warning
                $SkipCertificateCheck = $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck
            }
        }
    }
    else {
        # In case a computername was specified.
        if (-not [System.String]::IsNullOrEmpty($Computername)) {
            # Set the session variable to remember connection settings.
            $Script:MailcowHelperSession.ConnectParams.Computername = $Computername
            $Script:MailcowHelperSession.ConnectParams.ApiVersion = $ApiVersion
            $Script:MailcowHelperSession.ConnectParams.ApiKey = $ApiKey
            $Script:MailcowHelperSession.ConnectParams.Insecure = $Insecure.IsPresent
            $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck = $SkipCertificateCheck.IsPresent
        }
    }

    # Prepare the URI path used to check the status and therefore a successful connection/authentication.
    $UriPath = "get/status/version"

    # Prepare the parameters for the API call.
    $InvokeMailcowHelperRequestParams = @{
        UriPath              = $UriPath
        Method               = "GET"
        Insecure             = $Script:MailcowHelperSession.ConnectParams.Insecure
        SkipCertificateCheck = $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck
    }

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

    # Check the status code returned.
    if ($Result.PSObject.Properties.Name -contains "version") {
        # Initialize the session and set the autocomplete option.
        Initialize-MailcowHelperSession -DisableArgumentCompleter:$DisableArgumentCompleter.IsPresent

        # Return the result.
        $Result
    }
}

function Copy-DkimKey {
    <#
    .SYNOPSIS
        Copy a DKIM key from one domain to another.

    .DESCRIPTION
        Copy a DKIM key from one domain to another.

    .PARAMETER SourceDomain
        Domain name from where to copy the DKIM key.

    .PARAMETER TargetDomain
        The name of the domain for which to import the DKIM key.

    .EXAMPLE
        Copy-MHDkimKey -SourceDomain "source.example.com" -DestinationDomain "destination.example.com"

        Duplicates the DKIM key from domain "source.example.com" for the domain "destination.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Copy-DkimKey.md
    #>

    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Domain name from where to copy the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $SourceDomain,

        [Parameter(Position = 1, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to import the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $TargetDomain
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/dkim_duplicate"
    }

    process {
        foreach ($TargetDomainItem in $TargetDomain) {
            # Prepare the request body.
            $Body = @{
                from_domain = $SourceDomain
                to_domain   = $TargetDomainItem
            }

            if ($PSCmdlet.ShouldProcess("mailcow DKIM key", "Copy item")) {
                Write-MailcowHelperLog -Message "[$SourceDomain] --> [$TargetDomainItem] Copying DKIM key." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

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

function Get-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Get one or more BCC map definitions.

    .DESCRIPTION
        Get one or more BCC map definitions.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Id
        Id number of BCC map to get information for.
        If omitted, all BCC map definitions are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAddressRewriteBccMap

        Return all BCC maps.

    .EXAMPLE
        Get-MHAddressRewriteBccMap -Identity 15

        Returns BCC map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Id number of BCC map to get information for.")]
        [System.String[]]
        $Id = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/bcc/"
    }

    process {
        foreach ($IdItem in $Id) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID               = $Item.id
                        LocalDestination = $Item.local_dest
                        BccDestination   = $Item.bcc_dest
                        Active           = [System.Boolean][System.Int32]$Item.active
                        Type             = if ($Item.Type) { (Get-Culture).TextInfo.ToTitleCase($Item.type) }
                        Domain           = $Item.domain
                        WhenCreated      = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified     = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAddressRewriteBccMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Get one or more recipient map definitions.

    .DESCRIPTION
        Get one or more recipient map definitions.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER Id
        Id number of recipient map to get information for.
        If omitted, all recipient map definitions are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAddressRewriteRecipientMap

        Returns all recipient maps.

    .EXAMPLE
        Get-MHAddressRewriteRecipientMap -Identity 15

        Returns recipient map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Id number of recipient map to get information for.")]
        [System.String[]]
        $Id = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/recipient_map/"
    }

    process {
        foreach ($IdItem in $Id) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID              = $Item.id
                        RecipientMapOld = $Item.recipient_map_old
                        RecipientMapNew = $Item.recipient_map_new
                        Active          = [System.Boolean][System.Int32]$Item.active
                        WhenCreated     = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified    = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAddressRewriteRecipientMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-Admin {
    <#
    .SYNOPSIS
        Get information about one or more admin user accounts.

    .DESCRIPTION
        Get information about one or more admin user accounts.

    .PARAMETER Identity
        The username of the admin account for which to get information.
        If omitted, all admin user accounts are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAdmin

        Returns all admin user accounts.

    .EXAMPLE
        Get-MHAdmin -Identity superadmin

        Returns information about the admin user "superadmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The username of the admin account for which to get information.")]
        [Alias("Username")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/admin/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Username     = $Item.username
                        TfaActive    = [System.Boolean][System.Int32]$Item.tfa_active
                        TfaActiveInt = [System.Boolean][System.Int32]$Item.tfa_active_int
                        Active       = [System.Boolean][System.Int32]$Item.active
                        ActiveInt    = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAdmin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-AliasDomain {
    <#
    .SYNOPSIS
        Get information about one or more alias-domains.

    .DESCRIPTION
        Get information about one or more alias-domains.

    .PARAMETER Identity
        The name of the domain for which to get information.
        If omitted, all alias domains are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAliasDomain

        Returns all alias-domains.

    .EXAMPLE
        Get-MHAliasDomain -Identity alias.example.com

        Returns information for the alias-domain alias.example.com

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get information.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/alias-domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    if ($Item.rl.value) {
                        $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                    }
                    else {
                        $RateLimit = "Unlimited"
                    }
                    $ConvertedItem = [PSCustomObject]@{
                        AliasDomain      = $Item.alias_domain
                        TargetDomain     = $Item.target_domain
                        ParentIsBackupMX = [System.Boolean][System.Int32]$Item.parent_is_backupmx
                        Active           = [System.Boolean][System.Int32]$Item.active
                        ActiveInt        = [System.Boolean][System.Int32]$Item.active_int
                        RateLimit        = $RateLimit
                        WhenCreated      = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified     = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAliasDomain")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-AliasMail {
    <#
    .SYNOPSIS
        Get information about one ore more alias mail addresses.

    .DESCRIPTION
        Get information about one ore more alias mail addresses.

        This function supports two parametersets.
        Parameterset one allows to specify an alias email address for parameter "Identity".
        Parameterset two allows to specify the ID of an alias for parameter "AliasID".

    .PARAMETER Identity
        The alias mail address or ID for which to get information.
        If omitted, all alias domains are returned.

    .PARAMETER AliasId
        The ID number of the alias for which to get information.
        If omitted, all aliases are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailAlias

        Returns all aliases.

    .EXAMPLE
        Get-MHMailAlias -Identity alias@example.com

        Returns information for alias@example.com

    .EXAMPLE
        Get-MHMailAlias -AliasId 158

        Returns information for the alias with ID 158.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "AliasMail", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The alias mail address or ID for which to get information.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "AliasId", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of the alias for which to get information.")]
        [System.Int64[]]
        $AliasId,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/alias/"

        switch ($PSCmdlet.ParameterSetName) {
            "AliasMail" {
                if ([System.String]::IsNullOrEmpty($Identity)) {
                    # In case no specific mailbox name/mail address was given, use "All".
                    $RequestedIdentity = "All"
                }
                else {
                    # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
                    $RequestedIdentity = foreach ($Item in $Identity) {
                        $Item.Address
                    }
                }

                break
            }
            "AliasId" {
                # Set the requsted identity to the specified alias ID number(s).
                $RequestedIdentity = foreach ($AliasIdItem in $AliasId) { $AliasIdItem.ToString() }

                break
            }
            default {
                # Should not reach this point.
                throw "Unknown parameterset identified!"
            }
        }
    }

    process {
        foreach ($RequestedIdentityItem in $RequestedIdentity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($RequestedIdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID              = $Item.id
                        InPrimaryDomain = $Item.in_primary_domain
                        Domain          = $Item.domain
                        Goto            = $Item.goto
                        PublicComment   = $Item.public_comment
                        PrivateComment  = $Item.private_comment
                        Address         = $Item.address
                        IsCatchAll      = [System.Boolean][System.Int32]$Item.is_catch_all
                        Internal        = [System.Boolean][System.Int32]$Item.internal
                        SogoVisible     = [System.Boolean][System.Int32]$Item.sogo_visible
                        SogoVisibleInt  = [System.Boolean][System.Int32]$Item.sogo_visible_int
                        Active          = [System.Boolean][System.Int32]$Item.active
                        ActiveInt       = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated     = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified    = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAlias")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-AliasTimeLimited {
    <#
    .SYNOPSIS
        Get information about all time-limited aliases (spam-alias) defined for a mailbox.

    .DESCRIPTION
        Get information about all time-limited aliases (spam-alias) defined for a mailbox.

    .PARAMETER Identity
        The mail address of the mailbox for which to get the time-limited alias(es).
        If omitted, all time-limited aliases for all mailboxes are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAliasTimeLimited

        Returns time-limited aliases for all mailboxes.

    .EXAMPLE
        Get-MHAliasTimeLimited -Identity user@example.com

        Returns time-limited alias(es) for the mailbox user@example.com.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get the time-limited alias(es).")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/time_limited_aliases/"
    }

    process {
        if ([System.String]::IsNullOrEmpty($Identity)) {
            # Get all mailboxes.
            $Identity = (Get-Mailbox).username
        }

        # Loop through each specified mailbox.
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    if ($Item.Address) {
                        $ConvertedItem = [PSCustomObject]@{
                            Mailbox      = $IdentityItem.Address
                            Address      = $Item.address
                            Goto         = $Item.goto
                            Description  = $Item.description
                            Permanent    = [System.Boolean][System.Int32]$Item.permanent
                            Validity     = if ($Item.validity -ne 0) {
                                # The value for Validity is returned as Unix time (number of second since 1970).
                                # Convert it to DateTime value and add any offset to the local time zone.
                                $DateTimeUTC = $((Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.validity)))
                                $DateTimeUTC.ToLocalTime()
                            }
                            WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                            WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAliasTimeLimited")
                        $ConvertedItem
                    }
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-AppPassword {
    <#
    .SYNOPSIS
        Get application-specific password settings for a mailbox.

    .DESCRIPTION
        Get application-specific password settings for a mailbox.
        Passwords can not be returned in plain text.

    .PARAMETER Identity
        The mail address of the mailbox for which to get the app password setting for.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHAppPassword -Identity user@example.com

        Returns all app passwords for mailbox user@example.com.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get the app password for.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/app-passwd/all/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID           = $Item.id
                        Name         = $Item.name
                        Mailbox      = $Item.mailbox
                        Domain       = $Item.domain
                        Password     = "***"
                        IMAP         = [System.Boolean][System.Int32]$Item.imap_access
                        SMTP         = [System.Boolean][System.Int32]$Item.smtp_access
                        DAV          = [System.Boolean][System.Int32]$Item.dav_access
                        EAS          = [System.Boolean][System.Int32]$Item.eas_access
                        POP3         = [System.Boolean][System.Int32]$Item.pop3_access
                        Sieve        = [System.Boolean][System.Int32]$Item.sieve_access
                        Active       = [System.Boolean][System.Int32]$Item.active
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHAppPassword")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-BanList {
    <#
    .SYNOPSIS
        Get ban list entries from the fail2ban service.

    .DESCRIPTION
        Get ban list entries from the fail2ban service.
        This function is not using the mailcow rest API. Instead it calls the fail2ban banlist URI which can be retried using the mailcow REST API.

    .EXAMPLE
        Get-MHBanList

        Returns ban list items from mailcow"s fail2ban service.

    .INPUTS
        Nothing

    .OUTPUTS
        System.String

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-BanList.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param()

    # Get the current Fail2Ban config which includes the banlist_id value that is required to get the banlist.
    $Fail2BanConfig = Get-Fail2BanConfig -Raw

    # Prepare the banlist URI.
    $UriPath = "https://$($Script:MailcowHelperSession.ConnectParams.Computername)/f2b-banlist?id=$($Fail2BanConfig.banlist_id)"

    # Call the URI and get the result.
    Write-MailcowHelperLog -Message "Calling Uri [$UriPath]."
    $Result = Invoke-WebRequest -Uri $UriPath

    if ($null -ne $Result) {
        switch ($Result.StatusCode) {
            200 {
                if ([System.String]::IsNullOrEmpty($Result.Content)) {
                    Write-MailcowHelperLog -Message "Connection successful, but result is empty." -Level Information
                }
                else {
                    Write-MailcowHelperLog -Message "Connection successful."
                    $Result.Content
                }
                break
            }
            401 {
                Write-MailcowHelperLog -Message "Access denied / Not authorzied." -Level Warning
                break
            }
            default {
                # Return full result.
                $Result
                break
            }
        }
    }
}

function Get-DkimKey {
    <#
    .SYNOPSIS
        Get the DKIM key for a specific domain or for all domains.

    .DESCRIPTION
        Get the DKIM key for a specific domain or for all domains.

    .PARAMETER Identity
        Domain name to get DKIM key for.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDkimKey

        Returns DKIM keys for all domains.

    .EXAMPLE
        Get-MHDkimKey -Domain "example.com"

        Returns DKIM key for the domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Domain name to get DKIM key for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/dkim/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            if ($IdentityItem -eq "All") {
                # Get all mailcow domains first.
                $MailcowDomains = Get-Domain -Identity "All" -Raw

                # Call the function recursively for each domain.
                foreach ($MailcowDomainItem in $MailcowDomains) {
                    $GetMailcowDKIMParam = @{
                        Identity = $MailcowDomainItem.domain_name
                    }
                    Get-DKIMKey @GetMailcowDKIMParam
                }
            }
            else {
                # Build full Uri.
                $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

                # Execute the API call.
                $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

                # Return result.
                if ($Raw.IsPresent) {
                    # Return the result in raw format.
                    $Result
                }
                else {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            Domain        = $IdentityItem.ToLower()
                            PublicKey     = $Item.pubkey
                            KeyLength     = $Item.length
                            DKIM_TXT      = $Item.dkim_txt
                            DKIM_Selector = $Item.dkim_selector
                            PrivateKey    = $Item.privkey
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDkimKey")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult
                }
            }
        }
    }
}

function Get-Domain {
    <#
    .SYNOPSIS
        Get information about one or more domains registered on the mailcow server.

    .DESCRIPTION
        Get information about one or more domains registered on the mailcow server.

    .PARAMETER Identity
        The name of the domain for which to get information.
        By default, information for all domains are returned.

    .PARAMETER Tag
        A tag to filter the result on.
        This is only relevant if parameter "Identity" is not specified or if it is set to value "All" to return all domains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomain

        Return information for all domains.

    .EXAMPLE
        Get-MHDomain -Domain "example.com"

        Returns information for domain "example.com".

    .EXAMPLE
        Get-MHDomain -Tag "MyTag"

        Returns information for all domais tagged with "MyTag".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author: Dieter Koch
        Email: diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to request information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A tag to filter the result on.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

            # If specified, append the UrlEncoded tag values as comma separated list.
            if (-not [System.String]::IsNullOrEmpty($Tag)) {
                $RequestUriPath += "?tags=" + [System.Web.HttpUtility]::UrlEncode($Tag -join ",")
            }

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Get the rate limit and show it in a nicer way.
                    if ($Item.rl.value) {
                        $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                    }
                    else {
                        $RateLimit = "Unlimited"
                    }

                    # Get name of relayhost.
                    $RelayHostName = (Get-RoutingRelayHost -Id $Item.relayhost).Hostname

                    $ConvertedItem = [PSCustomObject]@{
                        DomainName            = $Item.domain_name
                        DomainHName           = $Item.domain_h_name
                        Description           = $Item.description
                        MaxNewMailboxQuota    = $Item.max_new_mailbox_quota
                        DefNewMailboxQuota    = $Item.def_new_mailbox_quota
                        QuotaUsedInDomain     = $Item.quota_used_in_domain
                        BytesTotal            = $Item.bytes_total
                        MsgsTotal             = $Item.msgs_total
                        MboxCount             = $Item.mboxes_in_domain
                        MboxesLeft            = $Item.mboxes_left
                        MaxNumAliases         = $Item.max_num_aliases_for_domain
                        MaxNumMboxes          = $Item.max_num_mboxes_for_domain
                        DefQuotaForMbox       = $Item.def_quota_for_mbox
                        MaxQuotaForMbox       = $Item.max_quota_for_mbox
                        MaxQuotaForDomain     = $Item.max_quota_for_domain
                        Relayhost             = $RelayHostName
                        AliasCount            = $Item.aliases_in_domain
                        AliasesLeft           = $Item.aliases_left
                        DomainAdmins          = $Item.domain_admins
                        BackupM               = [System.Boolean][System.Int32]$Item.backupmx
                        BackupMXInt           = [System.Boolean][System.Int32]$Item.backupmx_int
                        Gal                   = [System.Boolean][System.Int32]$Item.gal
                        GalInt                = [System.Boolean][System.Int32]$Item.gal_int
                        Active                = [System.Boolean][System.Int32]$Item.active
                        ActiveInt             = [System.Boolean][System.Int32]$Item.active_int
                        RelayAllRecipients    = [System.Boolean][System.Int32]$Item.relay_all_recipients
                        RelayAllRecipientsInt = [System.Boolean][System.Int32]$Item.relay_all_recipients_int
                        RelayUnknownOnly      = [System.Boolean][System.Int32]$Item.relay_unknown_only
                        RelayUnknownOnlyInt   = [System.Boolean][System.Int32]$Item.relay_unknown_only_int
                        RateLimit             = $RateLimit
                        WhenCreated           = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified          = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomain")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-DomainAdmin {
    <#
    .SYNOPSIS
        Get information about one or more domain admins.

    .DESCRIPTION
        Get information about one or more domain admins.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainAdmin

        Returns information for all domain admins.

    .EXAMPLE
        Get-MHDomainAdmin -Identity "MyDomainAdmin"

        Returns informatin for user with name "MyDomainAdmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The username for which to return information.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("DomainAdmin")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/domain-admin/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Append the specified string to the Uri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Username          = $Item.username
                        SelectedDomains   = $Item.selected_domains
                        UnselectedDomains = $Item.unselected_domains
                        TfaActive         = [System.Boolean][System.Int32]$Item.tfa_active
                        TfaActiveInt      = [System.Boolean][System.Int32]$Item.tfa_active_int
                        Active            = [System.Boolean][System.Int32]$Item.active
                        ActiveInt         = [System.Boolean][System.Int32]$Item.active_int
                        WhenCreated       = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainAdmin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Get blacklist or whitelist policies for a domain.

    .DESCRIPTION
        Get blacklist or whitelist policies for a domain.

    .PARAMETER Identity
        The name of the domain for which to get the AntiSpam policy.

    .PARAMETER ListType
        Either blacklist or whitelist.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainAntiSpamPolicy -ListType Whitelist

        Returns whitelist policies for all domains.

    .EXAMPLE
        Get-MHDomainAntiSpamPolicy -Domain "example.com" -ListType Blacklist

        Returns blacklits policies for domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The domain name to get information for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity = "All",

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "If specified, returns the blacklist records for the specified domain.")]
        [ValidateSet("Blacklist", "Whitelist")]
        [System.String]
        $ListType,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($ListType) {
            "Blacklist" {
                $UriPath = "get/policy_bl_domain/"
                break
            }
            "Whitelist" {
                $UriPath = "get/policy_wl_domain/"
                break
            }
            default {
                # Should not reach this point.
                throw "Error: Unknown listtype specified!"
            }
        }

        if ($Identity -eq "All") {
            # Get all domains.
            $MailcowDomains = (Get-Domain -Domain "All").DomainName
        }
        else {
            # Get the specified domain(s).
            $MailcowDomains = $Identity
        }
    }

    process {
        # Get specified list for each domain.
        foreach ($MailcowDomainItem in $MailcowDomains) {
            # Build full Uri.
            $RequestUriPath = $UriPath + $($MailcowDomainItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if (-not [System.String]::IsNullOrEmpty($Result)) {
                $ListCount = ($Result | Measure-Object).Count
                Write-MailcowHelperLog -Message "[$MailcowDomainItem] returned [$ListCount] policies."

                if ($Raw.IsPresent) {
                    # Return the result in raw format.
                    $Result
                }
                else {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            Object = $Item.object
                            Value  = $Item.value
                            PrefId = $Item.prefid
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainAntiSpamPolicy")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult
                }
            }
        }
    }
}

function Get-DomainTemplate {
    <#
    .SYNOPSIS
        Get information about domain templates.

    .DESCRIPTION
        Get information about domain templates.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHDomainTemplate

        Return all domain templates.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/domain/template"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            # Get the rate limit and show it in a nicer way.
            if ($Item.rl.value) {
                $RateLimit = "$($Item.attributes.rl.value) msgs/$($Item.attributes.rl.frame)"
            }
            else {
                $RateLimit = "Unlimited"
            }

            $ConvertedItem = [PSCustomObject]@{
                Id                 = $Item.id
                Name               = $Item.template
                Type               = $Item.type
                # Attributes         = $Item.attributes
                MaxNumAliases      = $Item.attributes.max_num_aliases_for_domain
                MaxNumMboxes       = $Item.attributes.max_num_mboxes_for_domain
                DefQuotaForMbox    = $Item.attributes.def_quota_for_mbox
                MaxQuotaForMbox    = $Item.attributes.max_quota_for_mbox
                MaxQuotaForDomain  = $Item.attributes.max_quota_for_domain
                Active             = [System.Boolean][System.Int32]$Item.attributes.active
                Gal                = [System.Boolean][System.Int32]$Item.attributes.gal
                BackupM            = [System.Boolean][System.Int32]$Item.attributes.backupmx
                RelayAllRecipients = [System.Boolean][System.Int32]$Item.attributes.relay_all_recipients
                RelayUnknownOnly   = [System.Boolean][System.Int32]$Item.attributes.relay_unknown_only
                RateLimit          = $RateLimit
                DkimSelector       = $Item.attributes.dkim_selector
                DkimKeySize        = $Item.attributes.key_size
                WhenCreated        = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified       = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHDomainTemplate")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-Fail2BanConfig {
    <#
    .SYNOPSIS
        Returns the fail2ban configuration of the mailcow server.

    .DESCRIPTION
        Returns the fail2ban configuration of the mailcow server.

    .EXAMPLE
        Get-MHFail2BanConfig

        Returns the fail2ban configuration of the mailcow server.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Fail2BanConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/fail2ban"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                BanTime          = $Item.ban_time
                BanTimeIncrement = $Item.ban_time_increment
                MaxBanTime       = $Item.max_ban_time
                NetBanIpv4       = $Item.netban_ipv4
                NetBanIpv6       = $Item.netban_ipv6
                MaxAttempts      = $Item.max_attempts
                RetryWindow      = $Item.retry_window
                BanlistID        = $Item.banlist_id
                Regex            = $Item.regex
                WhiteList        = $Item.whitelist
                BlackList        = $Item.blacklist

            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHFail2BanConfig")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-ForwardingHost {
    <#
    .SYNOPSIS
        Returns the forwarding hosts configured in mailcow.

    .DESCRIPTION
        Returns the forwarding hosts configured in mailcow.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHForwardingHost

        Returns the forwarding hosts configured in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/fwdhost/all"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                Host     = $Item.host
                Source   = $Item.source
                KeepSpam = $Item.keep_spam
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHForwardingHost")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-IdentityProvider {
    <#
    .SYNOPSIS
        Returns the identity provider configuration of the authentication source that is currently set in mailcow.

    .DESCRIPTION
        Returns the identity provider configuration of the authentication source that is currently set in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function returns the settings of the identity provider that is currently set as the active identity provider.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHIdentityProvider

        Returns the configuration of the currently active identity provider in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-IdentityProvider.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/identity-provider"
    }

    process {
        # Build full Uri.
        $RequestUriPath = $UriPath

        # Execute the API call.
        $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

        # Return result.
        if ($Raw.IsPresent -or $Result.authsource -ne "ldap") {
            # Return the result in raw format.
            # Currently a custom format is only available for LDAP auth source.
            $Result
        }
        else {
            switch ($Result.authsource) {
                "generic-oidc" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            AuthorizeUrl      = $Item.authorize_url
                            TokenUrl          = $Item.token_url
                            UserinfoUrl       = $Item.userinfo_url
                            ClientId          = $Item.client_id
                            ClientSecret      = $Item.client_secret
                            RedirectUrl       = $Item.redirect_url
                            RedirectUrlExtra  = $Item.redirect_url_extra
                            ClientScope       = $Item.client_scopes
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPGenericOIDCConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                "keycloak" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            ServerUrl         = $Item.server_url
                            Realm             = $Item.realm
                            ClientId          = $Item.client_id
                            ClientSecret      = $Item.client_secret
                            RedirectUrl       = $Item.redirect_url
                            RedirectUrlExtra  = $Item.redirect_url_extra
                            Version           = $Item.version
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            MailpasswordFlow  = $Item.mailpassword_flow
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            PeriodicSync      = [System.Boolean][System.Int32]$Item.periodic_sync
                            SyncInterval      = $Item.sync_interval
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPKeycloakConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                "ldap" {
                    # Prepare the result in a custom format.
                    $ConvertedResult = foreach ($Item in $Result) {
                        $ConvertedItem = [PSCustomObject]@{
                            AuthSource        = $Item.authsource
                            Host              = $Item.host
                            Port              = $Item.port
                            BaseDn            = $Item.basedn
                            BindDn            = $Item.binddn
                            BindPass          = $Item.bindpass
                            Filter            = $Item.filter
                            UsernameField     = $Item.username_field
                            AttributeField    = $Item.attribute_field
                            DefaultTemplate   = $Item.default_template
                            Mappers           = $Item.mappers
                            Templates         = $Item.templates
                            ImportUsers       = [System.Boolean][System.Int32]$Item.import_users
                            LoginProvisioning = [System.Boolean][System.Int32]$Item.login_provisioning
                            PeriodicSync      = [System.Boolean][System.Int32]$Item.periodic_sync
                            SyncInterval      = $Item.sync_interval
                            UseSsl            = [System.Boolean][System.Int32]$Item.use_ssl
                            UseTls            = [System.Boolean][System.Int32]$Item.use_tls
                            IgnoreSslError    = [System.Boolean][System.Int32]$Item.ignore_ssl_error

                            # The "edit/identity-provider" expects attribute name "ignore_ssl_error" (singular).
                            # The "get/identity-provider" returns "ignore_ssl_errors" (plural) with a boolean value (always $false) AND it returns "ignore_ssl_error" (singular) with either $null or $true, depending on what is really set for.
                            # So mailcow internally uses "ignore_ssl_error" (singular)" whereas "ignore_ssl_errors" (plural) seems to be incorrect.
                            # IgnoreSslErrors   = [System.Boolean][System.Int32]$Item.ignore_ssl_errors
                        }
                        $ConvertedItem.PSObject.TypeNames.Insert(0, "MHIdPLDAPConfig")
                        $ConvertedItem
                    }
                    # Return the result in custom format.
                    $ConvertedResult

                    break
                }
                default {
                    # Unknown IdP provider. Return raw result.
                    Write-MailcowHelperLog -Message "Unknown IdP authsource [$($Result.authsource)]. Return raw result." -Level Warning
                    $Result
                }
            }
        }
    }
}

function Get-Log {
    <#
    .SYNOPSIS
        Get mailcow server logs of the specified type.

    .DESCRIPTION
        Get mailcow server logs of the specified type.

    .PARAMETER Logtype
        Specify the type of log to return. Supported values are:
        Acme, Api, Autodiscover, Dovecot, Netfilter, Postfix, RateLimited, Rspamd-History, Sogo, Watchdog

    .PARAMETER Count
        The number of logs records to return. This always returns the latest (newest) log records.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHLog -LogType "Acme" -Count 100

        Get the last 100 records from the Acme log.

    .EXAMPLE
        Get-MHLog -LogType "Postfix"

        Get records from the Postfix log. By default the last 20 records are returned.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Log.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("Acme", "Api", "Autodiscover", "Dovecot", "Netfilter", "Postfix", "RateLimited", "Rspamd-History", "Sogo", "Watchdog")]
        [System.String]
        $Logtype,

        [Parameter(Position = 1, Mandatory = $false)]
        [ValidateRange(1, 9223372036854775807)]
        [System.Decimal]
        $Count = 20,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/logs/"

    # Build full Uri.
    $RequestUriPath = $UriPath + "$($Logtype.ToLower())/$count"
    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        switch ($Logtype) {
            "Acme" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Api" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Uri      = $Item.uri
                        Method   = $Item.method
                        Remote   = $Item.remote
                        Data     = $Item.data
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Autodiscover" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype   = $LogType
                        DateTime  = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        UserAgent = $Item.ua
                        Username  = $Item.user
                        Service   = $Item.service
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Dovecot" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Netfilter" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Priority = $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Postfix" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "RateLimited" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype       = $LogType
                        DateTime      = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        From          = $Item.from
                        HeaderFrom    = $Item.header_from
                        HeaderSubject = $Item.header_subject
                        IP            = $Item.ip
                        MessageId     = $Item.message_id
                        Qid           = $Item.qid
                        Rcpt          = $Item.rcpt
                        RlHash        = $Item.rl_hash
                        RlInfo        = $Item.rl_info
                        RlName        = $Item.rl_name
                        User          = $Item.user

                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Rspamd-History" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype       = $LogType
                        DateTime      = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Size          = $Item.size
                        SenderSmtp    = $Item.sender_smtp
                        RcptSmtp      = $Item.rcpt_smtp
                        RcptMime      = $Item.rcpt_mime
                        Subject       = $Item.subject
                        IsSkipped     = $Item.is_skipped
                        RequiredScore = $Item.required_score
                        TimeReal      = $Item.time_real
                        MessageId     = $Item."message-id"
                        IP            = $Item.ip
                        Thresholds    = $Item.thresholds
                        Action        = $Item.action
                        Symbols       = $Item.symbols
                        User          = $Item.user
                        Score         = $Item.score
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Sogo" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Program  = $Item.program
                        Priority = $Item.priority
                        Message  = $Item.message
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            "Watchdog" {
                # Prepare the result in custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Logtype  = $LogType
                        DateTime = if ($Item.time -ne 0) {
                            $DateTimeUTC = $(Get-Date -Date "1970-01-01T00:00:00") + ([System.TimeSpan]::FromSeconds($Item.time))
                            $DateTimeUTC.ToLocalTime()
                        }
                        Service  = $Item.service
                        Level    = $Item.lvl
                        hpnow    = $Item.hpnow
                        hptotal  = $Item.hptotal
                        hpdiff   = $Item.hpdiff
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHLog$LogType")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            default {
                # Return the result in raw format.
                Write-MailcowHelperLog -Message "Returning raw result for unknown log type."
                $Result
            }
        }
    }
}

function Get-Mailbox {
    <#
    .SYNOPSIS
        Return information about one or more mailboxes.

    .DESCRIPTION
        Return information about one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to get information.
        If omitted, all mailboxes are returned.

    .PARAMETER Tag
        A tag to filter the result on.
        This is only relevant if parameter "Identity" is not specified so to return all mailboxes.

    .PARAMETER Domain
        The name of the domain for which to get mailbox information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailbox

        Return information for all mailboxes on the mailcow server.

    .EXAMPLE
        Get-MHMailbox -Domain "example.com"

        Returns mailbox information for all mailboxes in domain "example.com".

    .EXAMPLE
        Get-MHMailbox -Tag "MyTag"

        Returns mailbox information for all mailboxes tagged with "MyTag"

    .EXAMPLE
        Get-MHMailbox -Domain "example.com" -Tag "MyTag"

        Returns mailbox information for all mailboxes tagged with "MyTag" in domain "example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Identity")]
    param(
        [Parameter(ParameterSetName = "Identity", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get mailbox information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(ParameterSetName = "Identity", Position = 1, Mandatory = $false, HelpMessage = "Specify a tag to filter.")]
        [Parameter(ParameterSetName = "Domain", Position = 1, Mandatory = $false, HelpMessage = "Specify a tag to filter.")]
        [System.String[]]
        $Tag,

        [Parameter(ParameterSetName = "Identity", Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [Parameter(ParameterSetName = "Domain", Position = 2, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Identity" {
                # Prepare the base Uri path.
                $UriPath = "get/mailbox/"
                if ([System.String]::IsNullOrEmpty($Identity)) {
                    # In case no specific mailbox name/mail address was given, use "All".
                    $RequestedIdentity = "All"
                }
                else {
                    # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
                    $RequestedIdentity = foreach ($IdentityItem in $Identity) {
                        $IdentityItem.Address
                    }
                }
                break
            }
            "Domain" {
                # Prepare the base Uri path.
                $UriPath = "get/mailbox/all/"
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" - Level Error
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            "Identity" {
                $Result = foreach ($IdentityItem in $RequestedIdentity) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())
                    if (-not [System.String]::IsNullOrEmpty($Tag)) {
                        $RequestUriPath += "?tags=" + [System.Web.HttpUtility]::UrlEncode($Tag.ToLower() -join ",")
                    }

                    # Execute the API call.
                    Invoke-MailcowApiRequest -UriPath $RequestUriPath
                }
                break
            }
            "Domain" {
                $Result = foreach ($DomainItem in $Domain) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + $DomainItem

                    # Execute the API call.
                    Invoke-MailcowApiRequest -UriPath $RequestUriPath
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" - Level Error
            }
        }

        # Return result.
        if ($Raw.IsPresent) {
            # Return the result in raw format.
            $Result
        }
        else {
            # Prepare the result in a custom format.
            $ConvertedResult = foreach ($Item in $Result) {
                # Get the rate limit and show it in a nicer way.
                if ($Item.rl.value) {
                    $RateLimit = "$($Item.rl.value) msgs/$($Item.rl.frame)"
                }
                else {
                    $RateLimit = "Unlimited"
                }

                $ConvertedItem = [PSCustomObject]@{
                    Username               = $Item.username
                    Active                 = [System.Boolean][System.Int32]$Item.active
                    ActiveInt              = [System.Boolean][System.Int32]$Item.active_int
                    Domain                 = $Item.domain
                    Name                   = $Item.name
                    LocalPart              = $Item.local_part

                    # Attributes           = $Item.attributes
                    ForcePasswordUpdate    = [System.Boolean][System.Int32]$Item.attributes.force_pw_update
                    EnforceTlsIn           = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_in
                    EnforceTlsOut          = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_out
                    SOGoAccess             = [System.Boolean][System.Int32]$Item.attributes.sogo_access
                    ImapAccess             = [System.Boolean][System.Int32]$Item.attributes.imap_access
                    Pop3Access             = [System.Boolean][System.Int32]$Item.attributes.pop3_access
                    SmtpAccess             = [System.Boolean][System.Int32]$Item.attributes.smtp_access
                    SieveAccess            = [System.Boolean][System.Int32]$Item.attributes.sieve_access
                    EasAccess              = [System.Boolean][System.Int32]$Item.attributes.eas_access
                    DavAccess              = [System.Boolean][System.Int32]$Item.attributes.dav_access
                    RelayHostId            = $Item.attributes.relayhost
                    PasswordUpdate         = if ($Item.attributes.passwd_update) { (Get-Date -Date $Item.attributes.passwd_update) }
                    MailboxFormat          = $Item.attributes.mailbox_format
                    QuarantineNotification = $Item.attributes.quarantine_notification
                    QuarantineCategory     = $Item.attributes.quarantine_category
                    RecoveryEmail          = $Item.attributes.recovery_email

                    CustomAttributes       = $Item.custom_attributes
                    QuotaUsed              = $Item.quota_used
                    PercentInUse           = $Item.percent_in_use
                    PercentClass           = $Item.pcerent_class
                    AuthSource             = $Item.authsource
                    MaxNewQuota            = $Item.max_new_quota
                    SpamAliases            = $Item.spam_aliases
                    PushoverActive         = [System.Boolean][System.Int32]$Item.pushover_active
                    RateLimit              = $RateLimit
                    RlScope                = $Item.rl_scope
                    IsRelayed              = [System.Boolean][System.Int32]$Item.is_relayed
                    WhenCreated            = if ($Item.created) { (Get-Date -Date $Item.created) }
                    WhenModified           = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    LastImapLogin          = if ($Item.last_imap_login) { (Get-Date -Date $Item.last_imap_login) }
                    LastSmtpLogin          = if ($Item.last_smtp_login) { (Get-Date -Date $Item.last_smtp_login) }
                    LastPop3Login          = if ($Item.last_pop3_login) { (Get-Date -Date $Item.last_pop3_login) }
                    LastSsoLogin           = if ($Item.last_sso_login) { (Get-Date -Date $Item.last_sso_login) }
                }
                $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailbox")
                $ConvertedItem
            }
            # Return the result in custom format.
            $ConvertedResult
        }
    }
}

function Get-MailboxLastLogin {
    <#
    .SYNOPSIS
        Return information about the last login to one or more mailboxes.

    .DESCRIPTION
        Return information about the last login to one or more mailboxes.

    .PARAMETER Identity
        The mail address for which to get information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxLastLogin -Identity "user123@example.com"

        Return the last login information for the user mailbox "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxLastLogin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/last-login/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result.sasl) {
                    $ConvertedItem = [PSCustomObject]@{
                        DateTime        = if ($Item.datetime) { (Get-Date -Date $Item.datetime) }
                        Service         = $Item.service
                        RealIP          = $Item.real_rip
                        AppPasswordUsed = [System.Boolean][System.Int32]$Item.app_password
                        AppPasswordName = $Item.app_password_name
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxLastLogin")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-MailboxSpamScore {
    <#
    .SYNOPSIS
        Get the spam score for one ore more mailboxes.

    .DESCRIPTION
        Get the spam score for one ore more mailboxes.

    .PARAMETER Identity
        The mail address for which to get information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxSpamScore

        Return spam score information for all mailboxes.

    .EXAMPLE
        Get-MHMailboxSpamScore -Identity "user1@example.com"

        Return spam score information for "user1@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxSpamScore.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Identity")]
    param(
        [Parameter(ParameterSetName = "Identity", Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/spam-score/"

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # If no identity was specified, get the mail address of all mailboxes.
            $Identity = (Get-Mailbox -Raw).username
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Getting spam-score for mailbox."
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Identity      = $IdentityItem.Address
                        SpamScoreLow  = if ($Item.Score) { ($Item.score -split ",")[0] }
                        SpamScoreHigh = if ($Item.Score) { ($Item.score -split ",")[1] }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxSpamScore")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-MailboxTemplate {
    <#
    .SYNOPSIS
        Get information about mailbox templates.

    .DESCRIPTION
        Get information about mailbox templates.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHMailboxTemplate

        Return all mailbox templates.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/mailbox/template"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            # Get the rate limit and show it in a nicer way.
            if ($Item.rl.value) {
                $RateLimit = "$($Item.attributes.rl.value) msgs/$($Item.attributes.rl.frame)"
            }
            else {
                $RateLimit = "Unlimited"
            }

            $ConvertedItem = [PSCustomObject]@{
                Id                       = $Item.id
                Name                     = $Item.template
                Type                     = $Item.type
                # Attributes   = $Item.attributes
                ForcePasswordUpdate      = [System.Boolean][System.Int32]$Item.attributes.force_pw_update
                EnforceTlsIn             = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_in
                EnforceTlsOut            = [System.Boolean][System.Int32]$Item.attributes.tls_enforce_out
                SOGoAccess               = [System.Boolean][System.Int32]$Item.attributes.sogo_access
                ImapAccess               = [System.Boolean][System.Int32]$Item.attributes.imap_access
                Pop3Access               = [System.Boolean][System.Int32]$Item.attributes.pop3_access
                SmtpAccess               = [System.Boolean][System.Int32]$Item.attributes.smtp_access
                SieveAccess              = [System.Boolean][System.Int32]$Item.attributes.sieve_access
                EasAccess                = [System.Boolean][System.Int32]$Item.attributes.eas_access
                DavAccess                = [System.Boolean][System.Int32]$Item.attributes.dav_access
                QuarantineNotification   = $Item.attributes.quarantine_notification
                QuarantineCategory       = $Item.attributes.quarantine_category
                MailboxQuota             = $Item.attributes.quota
                Tags                     = $Item.attributes.tags
                TaggedMailHandler        = $Item.attributes.tagged_mail_handler
                RateLimit                = $RateLimit
                Active                   = $Item.attributes.active
                AclSpamAlias             = $Item.attributes.acl_spam_alias
                AclTlsPolicy             = $Item.attributes.acl_tls_policy
                AclSpamScore             = $Item.attributes.acl_spam_score
                AclSpamPolicy            = $Item.attributes.acl_spam_policy
                AclDelimiterAction       = $Item.attributes.acl_delimiter_action
                AclSyncJobs              = $Item.attributes.acl_syncjobs
                AclEasReset              = $Item.attributes.acl_eas_reset
                AclSogoProfileReset      = $Item.attributes.acl_sogo_profile_reset
                AclPushover              = $Item.attributes.acl_pushover
                AclQuarantine            = $Item.attributes.acl_quarantine
                AclQuarantineAttachments = $Item.attributes.acl_quarantine_attachments
                AclQuarantineNotfication = $Item.attributes.acl_quarantine_notification
                AclQuarantineCategory    = $Item.attributes.acl_quarantine_category
                AclAppPasswords          = $Item.attributes.acl_app_passwds
                AclPasswordReset         = $Item.attributes.acl_pw_reset
                WhenCreated              = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified             = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHMailboxTemplate")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

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

function Get-MailcowHelperConfig {
    <#
    .SYNOPSIS
        Reads settings form a MailcowHelper config file.

    .DESCRIPTION
        Reads settings form a MailcowHelper config file.
        This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.
        If the specified file or the default config file does not exist, default settings are returned.

    .PARAMETER Path
        The full path to a MailcowHelper settings file (a JSON file).

    .PARAMETER Passthru
        If specified, returns the settings read from the file.
        Otherwise the settings are only stored in the module session variable and are therefore only accessable by functions in the module.

    .EXAMPLE
        Get-MHMailcowHelperConfig

        Tries to read settings from the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The full path to a MailcowHelper settings file (a JSON file).")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "If specified, returns the settings read from the file.")]
        [System.Management.Automation.SwitchParameter]
        $Passthru
    )

    # Define a default path if none was specified, depending on the OS.
    if ($null -eq $Path) {
        switch ($PSVersionTable.Platform) {
            "Win32NT" {
                $Path = "$env:USERPROFILE\.MailcowHelper.json"
                break
            }
            "Unix" {
                $Path = "$env:HOME\.MailcowHelper.json"
                break
            }
            default {
                Write-MailcowHelperLog -Message "Operating system not detected." -Level Warning
            }
        }
    }

    # Validate if the path exists.
    if (Test-Path -Path $Path) {
        # Read config from Path.
        Write-MailcowHelperLog -Message "Reading config from [$($Path.FullName)]."
        $Config = Get-Content -Path $Path | ConvertFrom-Json

        if ($Passthru.IsPresent) {
            $Config
        }
        else {
            if ($Config.SessionData) {
                $Script:MailcowHelperSession.ConnectParams = $Config.SessionData.ConnectParams
                if ($null -ne $Config.SessionData.ArgumentCompleterConfig) {
                    $Script:MailcowHelperSession.ArgumentCompleterConfig = $Config.SessionData.ArgumentCompleterConfig
                }

                # Convert ApiKey stored as secure string back to plain text.
                if (-not [System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiKey)) {
                    $Script:MailcowHelperSession.ConnectParams.ApiKey = $Script:MailcowHelperSession.ConnectParams.ApiKey | ConvertTo-SecureString | ConvertFrom-SecureString -AsPlainText
                }
            }
        }
    }
    else {
        Write-MailcowHelperLog -Message "The specified path is not valid [$($Path.FullName)]." -Level Warning
        Write-MailcowHelperLog -Message "Either specify the path to a valid MailcowHelper config file, or connect manually and save the config to a new file using "Set-MailcowHelperConfig"." -Level Warning

        # Use some default settings.
        $Script:MailcowHelperSession.ConnectParams = @{}
        $Script:MailcowHelperSession.ArgumentCompleterConfig = @{
            EnableFor = @(
                "Alias",
                "AliasDomain",
                "Domain",
                "DomainTemplate",
                "DomainAdmin",
                "Mailbox",
                "MailboxTemplate",
                "Resource"
            )
        }
    }
}

function Get-OauthClient {
    <#
    .SYNOPSIS
        Return OAuth client configuration.

    .DESCRIPTION
        Return OAuth client configuration.

    .PARAMETER Id
        The id value of a specific OAuth client.
        If omitted, all OAuth client configurations are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHOauthClient

        Returns all OAuth client configurations.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/oauth2-client/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID           = $Item.id
                        ClientId     = $Item.client_id
                        ClientSecret = $Item.client_secret
                        GrantTypes   = $Item.grant_types
                        RedirectUri  = $Item.redirect_uri
                        Scope        = $Item.scope
                        UserId       = $Item.user_id
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHOauthClient")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-PasswordPolicy {
    <#
    .SYNOPSIS
        Return the password policy configured in mailcow.

    .DESCRIPTION
        Return the password policy configured in mailcow.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHPasswordPolicy

        Returns the mailcow server password policy.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-PasswordPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/passwordpolicy"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                Length       = $Item.length
                Chars        = [System.Boolean][System.Int32]$Item.chars
                SpecialChars = [System.Boolean][System.Int32]$Item.special_chars
                LowerUpper   = [System.Boolean][System.Int32]$Item.lowerupper
                Numbers      = [System.Boolean][System.Int32]$Item.numbers
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHPasswordPolicy")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-Quarantine {
    <#
    .SYNOPSIS
        Get all mails that are currently in quarantine.

    .DESCRIPTION
        Get all mails that are currently in quarantine.

    .PARAMETER Id
        The id of the mail in the quarantine for which to get information.
        If omitted, all items in the quarantine are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHQuarantine -Id 17

        Returns information about the mail item with id 17.

    .EXAMPLE
        Get-MHQuarantine

        Returns information about all mails in the quarantine.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Quarantine.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The id of the mail in the quarantine for which to get information.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/quarantine/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Id          = $Item.id
                        QId         = $Item.qid
                        Notified    = [System.Boolean][System.Int32]$Item.notified
                        Recipient   = $Item.rcpt
                        Score       = $Item.score
                        Sender      = $Item.sender
                        Subject     = $Item.subject
                        VirusFlag   = [System.Boolean][System.Int32]$Item.virus_flag
                        WhenCreated = if ($Item.created) { (Get-Date -Date $Item.created) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHQuarantine")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-Queue {
    <#
    .SYNOPSIS
        Get the current mail queue and everything it contains.

    .DESCRIPTION
        Get the current mail queue and everything it contains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHQueue

        Get the current mail queue and everything it contains.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/mailq/all"

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                QueueId     = $Item.queue_id
                QueueName   = $Item.queue_name
                Recipients  = $Item.recipients
                Sender      = $Item.sender
                MessageSize = $Item.message_size
                ArrivalTime = if ($Item.arrival_time) { (Get-Date -Date $Item.arrival_time) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHQueue")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-Ratelimit {
    <#
    .SYNOPSIS
        Get the rate limit for one or more mailboxes or domains.

    .DESCRIPTION
        Get the rate limit for one or more mailboxes or domains.

    .PARAMETER Mailbox
        The mail address for which to get rate-limit information.

    .PARAMETER AllMailboxes
        If specified, get rate-limit information for all mailboxes.

    .PARAMETER Domain
        The name of the domain for which to get rate-limit information.

    .PARAMETER AllDomains
        If specified, get rate-limit information for all domains.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRatelimit

        By default, the rate-limit settings for all mailboxes are returned.

    .EXAMPLE
        Get-MHRatelimit -AllMailboxes

        Returns the rate limit settings for all mailboxes for which a rate-limit is set.

    .EXAMPLE
        Get-MHRatelimit -Domain "example.com"

        Returns the rate-limit settings for the domain "example.com".

    .EXAMPLE
        Get-MHRatelimit -AllDomains

        Returns the rate limit for all domains for which a rate-limit is set.

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Ratelimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for which to get rate-limit information.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "AllMailboxes", Position = 0, Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If specified, get rate-limit information for all mailboxes.")]
        [System.Management.Automation.SwitchParameter]
        $AllMailboxes,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to get rate-limit information.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(ParameterSetName = "AllDomains", Position = 0, Mandatory = $false, ValueFromPipeline = $false, HelpMessage = "If specified, get rate-limit information for all domains.")]
        [System.Management.Automation.SwitchParameter]
        $AllDomains,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        switch ($PSCmdlet.ParameterSetName) {
            "Mailbox" {
                # Prepare the base Uri path for mailbox based rate-limit.
                $UriPath = "get/rl-mbox/"
                $RequestedMailbox = foreach ($MailboxItem in $Mailbox) {
                    # The the mail address as string.
                    $MailboxItem.Address
                }
                break
            }
            "AllMailboxes" {
                if ($AllMailboxes.IsPresent) {
                    # Prepare the base Uri path for mailbox based rate-limit.
                    $UriPath = "get/rl-mbox/"
                    $RequestedMailbox = "all"
                }
                break
            }
            "Domain" {
                # Prepare the base Uri path for domain based rate-limit.
                $UriPath = "get/rl-domain/"
                if ($Domain -contains "all") {
                    # If the domain parameter was specified and one of the specified parameters is "all", then ignore all other specified values, in case there are some.
                    # This is just to prevent multiple API calls in case somebody specifies "all" together with individual domain names, which makes no sense.
                    $Domain = "all"
                }
                break
            }
            "AllDomains" {
                if ($AllDomains.IsPresent) {
                    # Prepare the base Uri path for domain based rate-limit.
                    $UriPath = "get/rl-domain/"
                    $Domain = "all"
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" -Level Error
            }
        }
    }

    process {
        switch ($PSCmdlet.ParameterSetName) {
            { $_ -eq "Mailbox" -or $_ -eq "AllMailboxes" } {
                foreach ($RequestedMailboxItem in $RequestedMailbox) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($RequestedMailboxItem.ToLower())

                    # Execute the API call.
                    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

                    # Return result.
                    if ($Raw.IsPresent) {
                        # Return the result in raw format.
                        $Result
                    }
                    else {
                        # Prepare the result in a custom format.
                        $ConvertedResult = foreach ($ResultItem in $Result) {
                            $ConvertedItem = [PSCustomObject]@{
                                Mailbox = $RequestedMailboxItem # there is no attribute mailbox in the result, if a specific mailbox is queried.
                                Value   = $ResultItem.value
                                Frame   = $ResultItem.frame
                            }
                            if ($null -ne $ResultItem.mailbox) {
                                # If the value for parameter mailbox is $null then the requested mailboxitem will be set to "all".
                                # In that case the result contains an attribute "mailbox" with the email address of the mailbox.
                                $ConvertedItem.Mailbox = $ResultItem.mailbox
                            }
                            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRatelimitMailbox")
                            $ConvertedItem
                        }
                        # Return the result in custom format.
                        $ConvertedResult
                    }
                }
                break
            }
            { $_ -eq "Domain" -or $_ -eq "AllDomains" } {
                foreach ($DomainItem in $Domain) {
                    # Build full Uri.
                    $RequestUriPath = $UriPath + $($DomainItem.ToLower())

                    # Execute the API call.
                    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

                    # Return result.
                    if ($Raw.IsPresent) {
                        # Return the result in raw format.
                        $Result
                    }
                    else {
                        # Prepare the result in a custom format.
                        $ConvertedResult = foreach ($ResultItem in $Result) {
                            $ConvertedItem = [PSCustomObject]@{
                                Domain = $DomainItem
                                Value  = $ResultItem.value
                                Frame  = $ResultItem.frame
                            }
                            if ($null -ne $ResultItem.mailbox) {
                                # If the value for parameter domain is $null then the requested domainitem will be set to "all".
                                # In that case the result contains an attribute "domain" with the domain name..
                                $ConvertedItem.Domain = $ResultItem.domain
                            }
                            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRatelimitDomain")
                            $ConvertedItem
                        }
                        # Return the result in custom format.
                        $ConvertedResult
                    }
                }
                break
            }
            default {
                # Should never reach this point.
                Write-MailcowHelperLog -Message "Error - invalid parameter set name!" -Level Error
            }
        }
    }
}

function Get-Resource {
    <#
    .SYNOPSIS
        Return information about one or more resource accounts.

    .DESCRIPTION
        Return information about one or more resource accounts.

    .PARAMETER Identity
        The mail address of the resource for which to get information.
        If omitted, all resources are returned.

    .PARAMETER All
        If specified, get information for all resources.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHResource -Identity "resourceABC@example.com"

        Returns information for resource with mail address "resourceABC@example.com".

    .EXAMPLE
        Get-MHResource

        Returns information for all resource accounts on a mailcow server.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the resource for which to get information.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [Alias("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/resource/"

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # In case no specific mailbox name/mail address was given, use "All".
            $ResourceIdentity = "All"
        }
        else {
            # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
            $ResourceIdentity = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
        }
    }

    process {
        foreach ($ResourceIdentityItem in $ResourceIdentity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($ResourceIdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $BookingLimit = $null
                    switch ($Item.multiple_bookings) {
                        -1 {
                            $MultipleBookings = "ShowBusyWhenBooked"
                            break
                        }
                        0 {
                            $MultipleBookings = "ShowAlwaysFree"
                            break
                        }
                        { $_ -ge 1 } {
                            $MultipleBookings = "HardLimit"
                            $BookingLimit = $Item.multiple_bookings
                            break
                        }
                        default {
                            # Unknown/unsupported value.
                        }
                    }

                    $ConvertedItem = [PSCustomObject]@{
                        Name             = $Item.name
                        ResourceType     = $Item.kind
                        MultipleBookings = $MultipleBookings
                        BookingLimit     = $BookingLimit
                        Active           = [System.Boolean][System.Int32]$Item.active
                        ActiveInt        = [System.Boolean][System.Int32]$Item.active_int
                        Description      = $Item.description
                        Domain           = $Item.domain
                        LocalPart        = $Item.local_part
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHResource")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-RoutingRelayHost {
    <#
    .SYNOPSIS
        Returns information about the relay hosts configured in a mailcow.

    .DESCRIPTION
        Returns information about the relay hosts configured in a mailcow.

    .PARAMETER Identity
        The ID number of a specific relay host record, or the keyword "All".
        If ommited, all configured relay hosts are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRoutingRelayHost

        Returns information for all relay hosts configured on a mailcow server.

    .EXAMPLE
        Get-MHRoutingRelayHost -Identity 1

        Returns information for relay host with ID 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific relay host record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/relayhost/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID              = $Item.id
                        Hostname        = $Item.hostname
                        Active          = [System.Boolean][System.Int32]$Item.active
                        Username        = $Item.username
                        Password        = if ($Item.password) { $Item.password | ConvertTo-SecureString -AsPlainText }
                        UsedByDomains   = $Item.used_by_domains
                        UsedByMailboxes = $Item.used_by_mailboxes
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRoutingRelayHost")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-RoutingTransport {
    <#
    .SYNOPSIS
        Return transport map configuration.

    .DESCRIPTION
        Return transport map configuration.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).

    .PARAMETER Id
        The ID number of a specific transport map record.
        If ommited, all configured transport map records are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRoutingTransport

        Returns all transport map configurations.

    .EXAMPLE
        Get-MHRoutingTransport -Identity 7

        Returns transport map configuration for transport map with ID 7.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/transport/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID          = $Item.id
                        Destination = $Item.destination
                        Active      = [System.Boolean][System.Int32]$Item.active
                        IsMxBased   = [System.Boolean][System.Int32]$Item.is_mx_based
                        Nexthop     = $Item.nexthop
                        Username    = $Item.username
                        Password    = if ($Item.password) { $Item.password | ConvertTo-SecureString -AsPlainText }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRoutingTransport")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-RspamdSetting {
    <#
    .SYNOPSIS
        Returns one or more Rspamd rules.

    .DESCRIPTION
        Returns one or more Rspamd rules.

    .PARAMETER Identity
        The ID number of a specific Rspamd rule.
        If ommited, all Rspamd rules are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHRspamdSetting -Id 1

        Returns rule with id 1.

    .EXAMPLE
        Get-MHRspamdSetting

        Returns all Rsapmd rules.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific Rspamd rule.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/rsetting/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem)

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Id          = $Item.id
                        Description = $Item.desc
                        Active      = [System.Boolean][System.Int32]$Item.active
                        Content     = $Item.content
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHRspamdSetting")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

function Get-SieveFilter {
    <#
    .SYNOPSIS
        Returns admin defined Sieve filters for one or more user mailboxes.

    .DESCRIPTION
        Returns admin defined Sieve filters for user mailboxes.
        Note that this will NOT return sieve filter scripts that a user has created on his/her own in SOGo,
        like out-of-office/vacation auto-reply or for example filter scripts to move incoming mails to folders.

    .PARAMETER Identity
        The mail address of the mailbox for which to return the Sieve script(s).
        If ommited, Sieve scripts for all mailboxes are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSieveFilter -Identity "user1@example.com"

        Returns Sieve scripts for the mailbox of "user1@example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "Mail address of mailbox to get information for.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/filters/all"
    }

    process {
        # Execute the API call.
        $ResultAll = Invoke-MailcowApiRequest -UriPath $UriPath

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # Return all results.
            $Result = $ResultAll
        }
        else {
            # Filter the result by the specied mail address(es).
            $MailAddresses = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            $Result = $ResultAll | Where-Object { $MailAddresses -eq $_.username }
        }

        # Return result.
        if ($Raw.IsPresent) {
            # Return the result in raw format.
            $Result
        }
        else {
            # Prepare the result in a custom format.
            $ConvertedResult = foreach ($Item in $Result) {
                $ConvertedItem = [PSCustomObject]@{
                    ID         = $Item.id
                    Username   = $Item.username
                    Active     = [System.Boolean][System.Int32]$Item.active
                    FilterType = $Item.filter_type
                    ScriptDesc = $Item.script_desc
                    ScriptData = $Item.script_data
                }
                $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSieveFilter")
                $ConvertedItem
            }
            # Return the result in custom format.
            $ConvertedResult
        }
    }
}

function Get-SieveGlobalFilter {
    <#
    .SYNOPSIS
        Return the global Sieve filter script.

    .DESCRIPTION
        Return the global Sieve filter script for the specified type.

    .PARAMETER FilterType
        The type of filter to return. Valid values are:
        All, PreFilter, PostFilter

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSieveGlobalFilter -All

        Returns the global pre- and post filter Sieve scripts.

    .EXAMPLE
        Get-MHSieveGlobalFilter -PreFilter

        Returns the global prefilter Sieve script.

    .EXAMPLE
        Get-MHSieveGlobalFilter -PostFilter

        Returns the global postfilter Sieve script.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveGlobalFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The type of filter to return.")]
        [ValidateSet("All", "PreFilter", "PostFilter")]
        $FilterType = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/global_filters/"

    # Prepare the RequestUri path.
    $RequestUriPath = $UriPath + $FilterType.ToLower()

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                PreFilter  = $Item.prefilter
                PostFilter = $Item.postfilter
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSieveGlobalFilter")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-Status {
    <#
    .SYNOPSIS
        Returns status information for the specified area for a mailcow server.

    .DESCRIPTION
        Returns status information for the specified area for a mailcow server.
        Accepted values for status area are:
        Containers, Host, Version, Vmail

    .PARAMETER Status
        The area for which to get status information.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHStatus -Status Containers

        Returns status for the mailcow containers.

    .EXAMPLE
        Get-MHStatus -Status Host

        Returns mailcow server host information.

    .EXAMPLE
        Get-MHStatus -Status Version

        Returns the mailcow server version.

    .EXAMPLE
        Get-MHStatus -Status Vmail

        Returns status for the mailcow vmail and the amount of used storage.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Status.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The area for which to get status information.")]
        [ValidateSet("Containers", "Host", "Version", "Vmail")]
        [System.String]
        $Status = "Version",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Prepare the base Uri path.
    $UriPath = "get/status/"

    # Build full Uri.
    $RequestUriPath = $UriPath + $Status.ToLower()

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    switch ($Status) {
        "Containers" {
            # Filter result for valid output.
            $Result = $Result.PSObject.Properties | Where-Object { $_.MemberType -eq "NoteProperty" } | ForEach-Object { $_.Value } | Sort-Object -Property Container

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        Type      = $Item.type
                        Container = $Item.container
                        State     = $Item.state
                        StartedAt = if ($Item.started_at) { (Get-Date -Date $Item.started_at) }
                        Image     = $Item.image
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }

            break
        }
        "Host" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $Uptime = New-TimeSpan -Seconds $Item.Uptime
                    $BootUptIme = (Get-Date).Add( - $($Uptime))

                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        CpuCores           = $Item.cpu.cores
                        CpuUsagePercent    = $Item.cpu.usage
                        MemoryTotalMB      = $Item.memory.total / 1MB
                        MemoryUsagePercent = $Item.memory.usage
                        MemorySwap         = $Item.memory.swap
                        UptimeSeconds      = $Uptime.TotalSeconds
                        UptimeInfo         = $("$($Uptime.Days)D $($Uptime.Hours)H $($Uptime.Minutes)M $($Uptime.Seconds)S")
                        BootUpTime         = $BootUptIme
                        SystemTime         = $Item.system_time
                        Architecture       = $Item.architecture
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }

            break
        }
        "Version" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        Version = $Item.version
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            break
        }
        "Vmail" {
            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    # Build the custom object.
                    $ConvertedItem = [PSCustomObject]@{
                        Type        = $Item.type
                        Disk        = $Item.disk
                        Total       = $Item.total
                        Used        = $Item.used
                        UsedPercent = $Item.used_percent
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHStatus$Status")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
            break
        }

        default {
            # Should never reach this point.
            Write-MailcowHelperLog -Message "Error - unknown status type defined!" -Level Errors
        }
    }
}

function Get-SyncJob {
    <#
    .SYNOPSIS
        Get information about all sync jobs on the mailcow server.

    .DESCRIPTION
        Get information about all sync jobs on the mailcow server.

    .PARAMETER IncludeLog
        Includes logs for each sync job.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSyncJob

        Returns all sync jobs.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Include logs for a sync job.")]
        [System.Management.Automation.SwitchParameter]
        $IncludeLog,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    if ($IncludeLog.IsPresent) {
        # Prepare the base Uri path.
        $UriPath = "get/syncjobs/all"
    }
    else {
        # Prepare the base Uri path.
        $UriPath = "get/syncjobs/all/no_log"
    }

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $UriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                ID                  = $Item.id
                Mailbox             = $Item.user2
                Subfolder           = $Item.subfolder2
                SourceAccout        = $Item.user1
                SourceHost          = $Item.host1
                SourcePort          = $Item.port1
                Active              = [System.Boolean][System.Int32]$Item.active
                Success             = [System.Boolean][System.Int32]$Item.success
                LastRun             = if ($Item.last_run) { (Get-Date -Date $Item.last_run) }

                AuthMech            = $Item.authmech1
                Encryption          = $Item.enc1
                RegexTrans2         = $Item.regextrans2
                Authmd51            = $Item.authmd51
                Domain2             = $Item.domain2
                Exclude             = $Item.exclude
                Maxage              = $Item.maxage
                MinsInterval        = $Item.mins_interval
                MaxBytesPerSecond   = $Item.maxbytespersecond
                Delete2Duplicates   = $Item.delete2duplicates
                Delete1             = $Item.delete1
                Delete2             = $Item.delete2
                Automap             = $Item.automap
                SkipCrossDuplicates = $Item.skipcrossduplicates
                CustomParams        = $Item.custom_params
                Timeout1            = $Item.timeout1
                Timeout2            = $Item.timeout2
                SubscribeAll        = [System.Boolean][System.Int32]$Item.subscribeall
                Dry                 = [System.Boolean][System.Int32]$Item.dry
                IsRunning           = [System.Boolean][System.Int32]$Item.is_running
                ExitStatus          = $Item.exit_status
                Log                 = $Item.log
                WhenCreated         = if ($Item.created) { (Get-Date -Date $Item.created) }
                WhenModified        = if ($Item.modified) { (Get-Date -Date $Item.modified) }
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSyncJob")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}

function Get-TlsPolicyMap {
    <#
    .SYNOPSIS
        Return TLS policy map override map.

    .DESCRIPTION
        Return TLS policy map override map.

    .PARAMETER Identity
        The ID of a specific policy map.
        If ommited, all tls policy maps are returned.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHTlsPolicyMap

        Returns all TLS policy map override maps.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The ID of a specific policy map.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "get/tls-policy-map/"

        # If no specific id was given, use the keyword "all" to return all.
        if ($null -eq $Id) {
            $Identity = "all"
        }
        else {
            $Identity = $Id
        }
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.ToLower())

            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

            # Return result.
            if ($Raw.IsPresent) {
                # Return the result in raw format.
                $Result
            }
            else {
                # Prepare the result in a custom format.
                $ConvertedResult = foreach ($Item in $Result) {
                    $ConvertedItem = [PSCustomObject]@{
                        ID           = $Item.id
                        Destination  = $Item.dest
                        Policy       = $Item.policy
                        Parameters   = $Item.parameters
                        Active       = [System.Boolean][System.Int32]$Item.active
                        WhenCreated  = if ($Item.created) { (Get-Date -Date $Item.created) }
                        WhenModified = if ($Item.modified) { (Get-Date -Date $Item.modified) }
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHTlsPolicyMap")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}

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

function Invoke-MailcowApiRequest {
    <#
    .SYNOPSIS
        Wrapper function for "Invoke-WebRequest" used to call the mailcow API.

    .DESCRIPTION
        Wrapper function for "Invoke-WebRequest" used to call the mailcow API.
        This function simplifies calling the API and is used by functions in this module.

    .PARAMETER UriPath
        Specify the path appended to the base URI.
        The base URI is build from the mailcow server name specified in "Connect-Mailcow", the string "/api/"
        the API version specified in "Connect-Mailcow" and the UriPath specified here.

    .PARAMETER Method
        Specify the HTTP method to use (GET or POST).

    .PARAMETER Body
        The request body.

    .PARAMETER Insecure
        If specified, use http instead of https.

    .PARAMETER Raw
        If specified, return the resulting content of the web request in raw format as JSON string instead of a PSCustomObject.

    .EXAMPLE
        Invoke-MHMailcowApiRequest -UriPath "get/status/version"

        Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version (requires to run "Connect-Mailcow" first).

    .EXAMPLE
        Invoke-MHMailcowApiRequest -UriPath "get/status/version" -Raw

        Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version as JSON string (requires to run "Connect-Mailcow" first).

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject,
        System.String

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Invoke-MailcowApiRequest.md
    #>

    [OutputType([PSCustomObject], [System.String])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Specify the path appended to the base URI.")]
        [System.String]
        $UriPath,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Specify the HTTP method to use (GET or POST).")]
        [ValidateSet("GET", "POST")]
        [System.String]
        $Method = "GET",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The request body.")]
        [System.Object]
        $Body,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "If specified, use http instead of https.")]
        [System.Management.Automation.SwitchParameter]
        $Insecure,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If specified, ignore certificate.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCertificateCheck,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "If specified, return the raw content data (JSON as System.String) instead of a PSCustomObject.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Check if the MailcowHelperSession variable already has information stored that is required to connect.
    if ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.Computername)) {
        Write-MailcowHelperLog -Message "No computername specified. Run 'Connect-Mailcow' and specify a computer name to connect to." -Level Error
    }
    elseif ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiVersion)) {
        Write-MailcowHelperLog -Message "No API version specified. Run 'Connect-Mailcow' and specify a valid API version." -Level Error
    }
    elseif ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiKey)) {
        Write-MailcowHelperLog -Message "No API key specified. Run 'Connect-Mailcow' and specify an API key." -Level Error
    }
    else {
        if ($Insecure.IsPresent -or $Script:MailcowHelperSession.ConnectParams.Insecure) {
            # Use http and show a warning about the Insecure connection.
            $Protocol = "http"
        }
        else {
            # By default use https.
            $Protocol = "https"
        }

        # Build full URI to request.
        $Uri = "$($Protocol)://$($Script:MailcowHelperSession.ConnectParams.Computername)/api/$($Script:MailcowHelperSession.ConnectParams.ApiVersion)/$($UriPath)"
        Write-MailcowHelperLog -Message "Requesting URI [$Uri]."

        # Prepare parameters for the WebRequest.
        $InvokeWebRequestParams = @{
            Uri                  = $Uri
            Method               = $Method
            ContentType          = "application/json"
            Headers              = @{
                "Content-type" = "application/json; charset=utf-8"
                "X-Api-Key"    = $Script:MailcowHelperSession.ConnectParams.ApiKey
            }
            SkipCertificateCheck = $($SkipCertificateCheck.IsPresent -or $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck)
            ErrorAction          = "Stop"
        }
        if ($null -ne $Body) {
            # Append body as JSON string.
            $InvokeWebRequestParams.Body = $Body | ConvertTo-Json -Depth 5
        }

        try {
            # Execute the web request.
            $Result = Invoke-WebRequest @InvokeWebRequestParams

            # Check result.
            if ($null -ne $Result) {
                switch ($Result.StatusCode) {
                    200 {
                        if ([System.String]::IsNullOrEmpty($Result.Content)) {
                            Write-MailcowHelperLog -Message "Connection successful, but not authorized." -Level Warning
                        }
                        else {
                            Write-MailcowHelperLog -Message "Connection successful."

                            if ($Raw.IsPresent) {
                                # Return the content received as it is.
                                $Result.Content
                            }
                            else {
                                if ($Result.Content -eq "{}") {
                                    # Received an empty JSON object. We don't want to return an empty object.
                                    Write-MailcowHelperLog -Message "Received empty result."
                                }
                                else {
                                    # Convert the received JSON object ot a PSCustomObject and return it.
                                    $Result.Content | ConvertFrom-Json
                                }
                            }
                        }
                        break
                    }
                    default {
                        # tbd
                        break
                    }
                }
            }
        }
        catch {
            $ErrorRecord = $_
            if ($null -eq $ErrorRecord) {
                throw "Error connecting to mailcow server [$Computername]."
            }
            else {
                throw "Error connecting to mailcow server [$Computername]: [$($ErrorRecord.ErrorDetails.Message)]"
            }
        }
    }
}

function New-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Add a new BCC map.

    .DESCRIPTION
        Add a new BCC map.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Identity
        The mail address or the name of the domain for which to add a BCC map.

    .PARAMETER BccDestination
        The bcc target.

    .PARAMETER BccType
        Either "Sender" or "Recipient".
        "Sender" means, that the rule will be applied for mails sent from the mail address or domain specified by the "Identity" parameter.
        "Recipient" means, that the rule will be applied for mails sent to the mail address or domain specified by the "Identity" parameter.

    .PARAMETER Enable
        By default new BCC maps are always enabled.
        To add a new BCC map in disabled state, specify "-Enable:$false".

    .EXAMPLE
        New-MHAddressRewriteBccMap -Identity "user1@example.com" -BccDestination "user2@example.com" -BccType "Recipient"

        This adds a BCC map so every mail sent to mailbox "user1@example.com" is BCCed to "user2@example.com".

    .EXAMPLE
        New-MHAddressRewriteBccMap -Identity "sub.example.com" -BccDestination "admin@example.com" -BccType "Recipient"

        This adds a BCC map so every mail sent to domain "sub.example.com" is BCCed to "admin@example.com".

    .EXAMPLE
        New-MHAddressRewriteBccMap -Identity "support@example.com" -BccDestination "suppport-manager@example.com" -BccType "Sender"

        This adds a BCC map so every mail sent from mailbox "support@example.com" is BCCed to "suppport-manager@example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address or the name of the domain for which to create a BCC map.")]
        [MailcowHelperArgumentCompleter(("Mailbox", "Domain"))]
        [Alias("Mailbox", "Domain", "LocalDestination")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The bcc target.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Target")]
        [System.Net.Mail.MailAddress]
        $BccDestination,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Create either Sender or Recipient based BCC map.")]
        [ValidateSet("Sender", "Recipient")]
        [Alias("Type")]
        [System.String]
        $BccType = "Sender",

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or Disable the new BCC map.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/bcc"
    }

    process {
        foreach ($AddressItem in $DomainOrMailAddress) {
            # Prepare the request body.
            $Body = @{
                local_dest = $AddressItem
                bcc_dest   = $BccDestination.Address
                type       = $BccType.ToLower()
                # By default enable the new BCC map.
                active     = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("BCC map", "Add")) {
                Write-MailcowHelperLog -Message "Adding BCC map for [$AddressItem] -> [$($BccDestination.Address)] of type [$($BccType.ToLower())]." -Level Information
                # Execute the API call.
                $Result = Invoke-MailcowApiRequest -UriPath $UriPath -Method Post -Body $Body

                # Return the result.
                $Result
            }
        }
    }
}

function New-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Add a new address rewriting recipient map.

    .DESCRIPTION
        Add a new address rewriting recipient map.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER OriginalDomainOrMailAddress
        The domain or mail address for which to redirect mails.

    .PARAMETER TargetDomainOrMailAddress
        The target domain or mail address.

    .PARAMETER Enable
        Enable or disable the recipient map.

    .EXAMPLE
        New-MHAddressRewriteRecipientMap -OriginalDomainOrMailAddress sub.example.com -TargetDomainOrMailAddress example.com

        Redirects all mails send to domain "sub.example.com" to the domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain or mail address for which to redirect mails.")]
        [MailcowHelperArgumentCompleter(("Domain", "Mailbox"))]
        [System.String[]]
        $OriginalDomainOrMailAddress,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The target domain or mail address.")]
        [MailcowHelperArgumentCompleter(("Domain", "Mailbox"))]
        [System.String]
        $TargetDomainOrMailAddress,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the recipient map.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/recipient_map"
    }

    process {
        foreach ($AddressItem in $OriginalDomainOrMailAddress) {
            # Prepare the request body.
            $Body = @{
                recipient_map_old = $AddressItem.Trim()
                recipient_map_new = $TargetDomainOrMailAddress.Trim()
                # By default enable the new BCC map.
                active            = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("recipient map", "Add")) {
                Write-MailcowHelperLog -Message "Adding recipient map for [$AddressItem] -> [$($TargetDomainOrMailAddress.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-Admin {
    <#
    .SYNOPSIS
        Add a new admin user account on the mailcow server.

    .DESCRIPTION
        Add a new admin user account on the mailcow server.

    .PARAMETER Username
        The login name for the new admin user account.

    .PARAMETER Password
        The password for the new admin user account as secure string.

    .PARAMETER Enable
        Enable or disable the new admin user account. By default all new admin accounts are created in enabled state.
        Use "-Enable:$false" to create an account in disabled state.

    .EXAMPLE
        New-MHAdmin -Username "cowboy"

        This will create a new admin user account named "cowboy". The password is mandatory and requested to be typed in as secure string.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Username of the admin user account to create.")]
        [Alias("Identity")]
        [System.String[]]
        $Username,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The password for the new admin user account as secure string.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the new admin user account. ")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/admin"
    }

    process {
        foreach ($UsernameItem in $Username) {
            # Prepare the request body.
            $Body = @{
                username  = $UsernameItem
                password  = $Password | ConvertFrom-SecureString -AsPlainText
                password2 = $Password | ConvertFrom-SecureString -AsPlainText
                active    = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("admin user account [$UsernameItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding admin user account [$UsernameItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-AliasDomain {
    <#
    .SYNOPSIS
        Adds a new alias domain.

    .DESCRIPTION
        Adds a new alias domain.

    .PARAMETER Identity
        The new alias domain name.

    .PARAMETER TargetDomain
        The target domain for the new alias.

    .PARAMETER Enable
        Enable or disable the new alias domain.
        By default all new alias domains are created in enabled state.

    .EXAMPLE
        New-MHAliasDomain -Identity "alias.example.com" -TargetDomain "example.com"

        Adds an alias domain "alias.example.com" for domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The new alias domain name.")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The target domain for the new alias domain.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $TargetDomain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the new alias domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                # By default, activate the new alias domain.
                active        = 1
                # Set the Alias domain name.
                alias_domain  = $IdentityItem.Trim().ToLower()
                # Set the target domain name for the alias domain.
                target_domain = $TargetDomain.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "add")) {
                Write-MailcowHelperLog -Message "Adding alias domain [$IdentityItem]." -Level Information
                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-AliasMail {
    <#
    .SYNOPSIS
        Add an alias mail address.

    .DESCRIPTION
        Add an alias mail address.

    .PARAMETER Identity
        The new alias mail address to create.

    .PARAMETER Destination
        The destination mail address(es) for the new alias.
        Specifying multiple destination addresses basically creates a distribution list.

    .PARAMETER SilentlyDiscard
        Silently discard mail messages sent to the alias address.

    .PARAMETER LearnAsSpam
        All mails sent to the alias are treated as spam (blacklisted).

    .PARAMETER LearnAsHam
        All mails sent to the alias are treated as "ham" (whitelisted).

    .PARAMETER Enable
        Enable or disable the new alias.
        By default the new alias address is enabled. To create a disable alias use "-Enable:$false".

    .PARAMETER Internal
        Internal aliases are only accessible from the own domain or alias domains.

    .PARAMETER SOGoVisible
        Make the new alias visible ein SOGo.

    .PARAMETER PublicComment
        Specify a public comment.

    .PARAMETER PrivateComment
        Specify a private comment.

    .PARAMETER AllowSendAs
        Allow the destination mailbox uesrs to SendAs the alias.

    .EXAMPLE
        New-MHAliasMail -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible

        Creates an alias "alias@example.com" for mailbox "mailbox@example.com". The alias will be visible for the user in SOGo.

    .EXAMPLE
        New-MHAliasMail -Alias "alias2@example.com" -Destination "mailbox@example.com" -SOGoVisible -AllowSendAs

        Creates alias "alias2@example.com" for mailbox "mailbox@example.com". The alias will be visible for the user in SOGo.
        The user of "mailbox@example.com" will get the permission to SendAs the alias.

    .EXAMPLE
        New-MHAliasMail -Alias "spam@example.com" -Destination "mailbox@example.com" -LearnAsSpam

        Creates an alias "spam@example.com" for mailbox "mailbox@example.com". Mails sent to the new alias will be treated as spam.

    .EXAMPLE
        New-MHAliasMail -Alias "groupA@example.com" -Destination "user1@example.com", "user2@example.com"

        This creates an alias that acts like a distribution group because mails to the alias are forwarded to two mailboxes.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias mail address to create.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress]
        $Identity,

        [Parameter(ParameterSetName = "DestinationMailbox", Position = 1, Mandatory = $false, HelpMessage = "The destination mail address for the new alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Destination,

        [Parameter(ParameterSetName = "DestinationDiscard", Position = 2, Mandatory = $false, HelpMessage = "Silently discard mail messages sent to the alias address.")]
        [System.Management.Automation.SwitchParameter]
        $SilentlyDiscard,

        [Parameter(ParameterSetName = "DestinationSpam", Position = 3, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as spam (blacklisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsSpam,

        [Parameter(ParameterSetName = "DestinationHam", Position = 4, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as ham (whitelisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsHam,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the new alias.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Internal aliases are only accessible from the own domain or alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $Internal,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Make the new alias visible ein SOGo.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoVisible,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify a public comment.")]
        [System.String]
        $PublicComment,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify a private comment.")]
        [System.String]
        $PrivateComment,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Allow the destination mailbox uesrs to SendAs the alias.")]
        [System.Management.Automation.SwitchParameter]
        $AllowSendAs
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/alias"
    }

    process {
        foreach ($AliasItem in $Alias) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = @{
                # By default, activate the new alias.
                active  = 1
                # Set the Alias address.
                address = $AliasItem.Address
            }
            if ($PSBoundParameters.ContainsKey("Destination")) {
                # Set the specified destination address.
                $Destinations = foreach ($DestinationItem in $Destination) { $DestinationItem.Address }
                $Body.goto = [System.String]$Destinations -join ","
            }
            if ($PSBoundParameters.ContainsKey("SilentlyDiscard")) {
                # Set the destination to "null@localhost".
                $Body.goto_null = "1"
            }
            if ($PSBoundParameters.ContainsKey("LearnAsSpam")) {
                # Set the destination to "spam@localhost".
                $Body.goto_spam = "1"
            }
            if ($PSBoundParameters.ContainsKey("LearnAsHam")) {
                # Set the destination to "ham@localhost".
                $Body.goto_ham = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Internal")) {
                # Set if the alias should be reachable only internal.
                $Body.internal = if ($Internal.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SOGoVisible")) {
                # Set if the alias should be availabl ein SOGo.
                $Body.sogo_visible = if ($SOGoVisible.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("PublicComment")) {
                # Set the public comment for the alias.
                $Body.public_comment = $PublicComment
            }
            if ($PSBoundParameters.ContainsKey("PrivateComment")) {
                # Set the private comment for the alias.
                $Body.private_comment = $PrivateComment
            }
            if ($PSBoundParameters.ContainsKey("AllowSendAs")) {
                # Set SenderAllowed option.
                $Body.sender_allowed = if ($AllowSendAs.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("alias [$AliasItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding alias [$AliasItem]." -Level Information
                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-AliasTimeLimited {
    <#
    .SYNOPSIS
        Adds a time-limited alias (spamalias) to a mailbox.

    .DESCRIPTION
        Adds a time-limited alias (spamalias) to a mailbox.

    .PARAMETER Identity
        The mail address of the mailbox for which to create a time-limited alias.

    .PARAMETER ForAliasDomain
        The alias domain in which to create a new time-limited alias.
        This must be an alias domain that is valid for the specified user"s primary domain.

    .PARAMETER Description
        Description for the time-limited alias.
        The description can only be set during creation. It can not be updated afterwards (neither in the WebGui nor via the API).

    .PARAMETER Permanent
        If specified, the time-limit alias will be set to never expire.
        Otherwise any new time-limited alias will be set to expire in 1 year.
        You can use "Set-AliasTimeLimited" to change the the validity period afterwards.

    .PARAMETER ExpireIn
        Set a predefined time period. Allowed values are:
        1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

    .PARAMETER ExpireInHours
        Set a custom value as number of hours from now.
        The valid range is 1 to 105200, which is between 1 hour and about 12 years.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Permanent

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The new alias will not expire.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The alias will by default be valid for/expire in 1 year.

    .EXAMPLE
        New-MHAliasTimeLimited -Identity "mailbox@example.com" -Description "Dummy alias"
        $NewAliasAddress = (Get-MHAliasTimeLimited -Identity "mailbox@example.com" | Sort-Object -Property WhenCreated | Select-Object -Last 1).Address
        $NewAliasAddress | Set-MHAliasTimeLimited -ExpireIn 1Week

        This will add a new time-limited alias for the mailbox "mailbox@example.org". The alias will by default be valid for/expire in 1 year.
        Then the newest alias address is stored in $NewAliasAddress" and the expiration is set to 1 week.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "ExpireIn", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to create a time-limited alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The alias domain in which to create a new time-limited alias.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String]
        $ForAliasDomain,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Description for the time-limited alias.")]
        [System.String]
        $Description,

        [Parameter(ParameterSetName = "Permanent", Position = 3, Mandatory = $false, HelpMessage = "If specified, the time-limited alias will not expire.")]
        [System.Management.Automation.SwitchParameter]
        $Permanent,

        [Parameter(ParameterSetName = "ExpireIn", Position = 3, Mandatory = $false, HelpMessage = "Set when the time-limited alias should expire by selecting from a list of timeframes.")]
        [ValidateSet("1Hour", "1Day", "1Week", "1Month", "1Year", "10Years")]
        [System.String]
        $ExpireIn = "1Year",

        [Parameter(ParameterSetName = "ExpireInHours", Position = 3, Mandatory = $false, HelpMessage = "Specify in how many hours the time-limited alias should exipre.")]
        [ValidateRange(1, 105200)]
        [System.Int32]
        $ExpireInHours
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/time_limited_alias"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                username = $IdentityItem.Address
                # Set the domain either to the specified alias domain or to the mailbox domain.
                domain   = if (-not [System.String]::IsNullOrEmpty($ForAliasDomain)) { $ForAliasDomain } else { $IdentityItem.Host }

                # Theoretically it would be possible to specifiy a validity argument in the API call.
                # The validity value is the number of hours from now in a range of 1 to 87600. The API function accepts the value
                # See "data/web/inc/functions.mailbox.inc.php".
                # The problem is, that the API overwrites any valid results with the value 8760 (hours) which is 365 days, so one year.
                # If "validity" is missing, then also 1 year is the default. Any invalid or out-of-range values will lead to an error.
                # Finally all time limited aliases are created by default for 1 year
                # However, it is possible to change the validity using the "Set-AliasTimeLimited" function for an existing alias.
                # Or the user can change in the SOGo WebGUI.
                # This is as of 2026-JAN-18
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                # The description can only be set during creation. It can not be updated afterwards (neither in the WebGui nor via the API).
                $Body.description = $Description
            }
            if ($PSBoundParameters.ContainsKey("Permanent")) {
                $Body.permanent = if ($Permanent.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("time-limited alias to mailbox [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding time-limited alias to mailbox [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-AppPassword {
    <#
    .SYNOPSIS
        Add a new application-specific password for a mailbox user.

    .DESCRIPTION
        Add a new application-specific password for a mailbox user.

    .PARAMETER Identity
        The mail address of the mailbox for which to add an app password.

    .PARAMETER Name
        A name for the app password.

    .PARAMETER Password
        The password to set.

    .PARAMETER Protocol
        The protocol(s) for which the app password can be used.
        One or more of the following values:
        IMAP, DAV, SMTP, EAS, POP3, Sieve

    .PARAMETER Enable
        Enable or disable the app password.

    .EXAMPLE
        New-MHAppPassword -Identity "user1@example.com" -Name "New name for app password" -Protcol "EAS"

        Add an application-specific password for "user1@example.com" that can be used for Active Sync connections.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to add an app password.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "A name for the app password.")]
        [Alias("AppName")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The password to set.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The protocol(s) for which the app password can be used.")]
        [ValidateSet("IMAP", "DAV", "SMTP", "EAS", "POP3", "Sieve")]
        [System.String[]]
        $Protocol,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the app password.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/app-passwd"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                username    = $IdentityItem.Address
                app_name    = $Name
                app_passwd  = $Password | ConvertFrom-SecureString -AsPlainText
                app_passwd2 = $Password | ConvertFrom-SecureString -AsPlainText
                active      = "1"
            }
            if ($PSBoundParameters.ContainsKey("Protocol")) {
                $Body.protocols = foreach ($ProtocolItem in $Protocol) { $($ProtocolItem.ToLower()) + "_access" }
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("app password for mailbox [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding app password for mailbox [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-DkimKey {
    <#
    .SYNOPSIS
        Adds a DKIM key for a domain.

    .DESCRIPTION
        Adds a DKIM key for a domain.

    .PARAMETER Domain
        The name of the domain for which to create a DKIM key.

    .PARAMETER DkimSelector
        The DKIM selector name.
        By defaults set to "dkim".

    .PARAMETER KeySize
        The keysize for the DKIM key.
        By defaults set to 2096.
        Allowed values are 1024, 2024, 4096, 8192.

    .EXAMPLE
        New-MHDkimKey -Domain "example.com" -DkimSelector "dkim2026" -KeySize 2048

        Adds a new DKIM key for domain "example.com" with DKIM selector name "dkim2026" and a keysize of 2048.

    .EXAMPLE
        (Get-Domain).DomainName | New-MHDkimKey

        Creates a new DKIM key for each mailcow domain using the default options.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to create a DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The DKIM selector name.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The keysize for the DKIM key.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $KeySize = 2096
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/dkim"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = @{
                domains       = $DomainItem
                dkim_selector = $DkimSelector
                key_size      = $KeySize
            }

            if ($PSCmdlet.ShouldProcess("admin DKIM key for domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding DKIM key for domain [$DomainItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-Domain {
    <#
    .SYNOPSIS
        Add a domain to mailcow server.

    .DESCRIPTION
        Add a domain to mailcow server.

    .PARAMETER Domain
        The domain name to add.

    .PARAMETER Description
        A description for the new domain.

    .PARAMETER Enable
        Enable or disable the domain.

    .PARAMETER MaxMailboxCount
        Specify the maximum number of mailboxes allowed for the domain.
        Defaults to 10.

    .PARAMETER MaxAliasCount
        Specify the maximum number of aliases allowed for the domain.
        Defaults to 400.

    .PARAMETER DefaultMailboxQuota
        Specify the default mailbox quota.
        Defaults to 3072.

    .PARAMETER MailboxQuota
        Specify the maximum mailbox quota.
        Defaults to 10240.

    .PARAMETER TotalDomainQuota
        Specify the total domain quota valid for all mailboxes in the domain.
        Defaults to 10240.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain.

    .PARAMETER Tag
        Add one or more tags to the new domain.

    .PARAMETER RateLimit
        Set the message rate limit for the domain.
        Defaults to 10.

    .PARAMETER RateLimitPerUnit
        Set the message rate limit unit.
        Defaults to seconds.

    .PARAMETER RestartSogo
        If specified, SOGo will be restarted after adding the domain.

    .PARAMETER Template
        The name of a domain template to use to get default values based on the template.

    .EXAMPLE
        New-MHDomain -Domain "example.com"

        Adds a new domain "example.com" to the mailcow server using default values from the default template.

    .EXAMPLE
        New-MHDomain -Domain "example.com" -Template "MyTemplate"

        Adds a new domain "example.com" to the mailcow server using default values from the "MyTemplate" domain template.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to add.")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A description for the new domain.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Specify the maximum number of mailboxes allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxCount = 10,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Specify the maximum number of aliases allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxAliasCount = 400,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Specify the default mailbox quota.")]
        # Default mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $DefaultMailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specify the maximum mailbox quota.")]
        # Max. mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $MailboxQuota = 10240,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify the total domain quota valid for all mailboxes in the domain.")]
        # Total domain quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $TotalDomainQuota = 10240,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Add one or more tags to the new domain.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Set the message rate limit for the domain.")]
        [ValidateRange(0, 9223372036854775807)]
        [System.Int64]
        $RateLimit = 10,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Set the message rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitPerUnit = "Seconds",

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "If specified, SOGo will be restarted after adding the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RestartSogo,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "The name of a domain template to use to get default values based on the template.")]
        [MailcowHelperArgumentCompleter("DomainTemplate")]
        [System.String]
        $Template
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain/"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($DomainItem.ToLower())"

            # Prepare the request body.
            $Body = @{
                domain = $DomainItem.Trim()
            }

            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("MaxAliasCount")) {
                $Body.aliases = $MaxAliasCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
                $Body.defquota = $DefaultMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                if (-not [System.String]::IsNullOrEmpty($Description)) {
                    $Body.description = $Description
                }
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxCount")) {
                $Body.mailboxes = $MaxMailboxCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("TotalDomainQuota")) {
                $Body.quota = $TotalDomainQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.maxquota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
                $Body.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
                $Body.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
                $Body.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
                $Body.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitPerUnit")) {
                $Body.rl_frame = $RateLimitPerUnit.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("RateLimit")) {
                $Body.rl_value = $RateLimit.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RestartSogo")) {
                $Body.restart_sogo = if ($RestartSogo.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                if (-not [System.String]::IsNullOrEmpty($Tag)) {
                    $Body.tags = $Tag
                }
            }
            if ($PSBoundParameters.ContainsKey("Template")) {
                # If no template is specified, the API will use values from the default domain template for values that have not been explicitly specified otherwise.
                if (-not [System.String]::IsNullOrEmpty($Template)) {
                    $Body.template = $Template
                }
            }

            if ($PSCmdlet.ShouldProcess("domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding domain [$DomainItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-DomainAdmin {
    <#
    .SYNOPSIS
        Add a domain admin user account.

    .DESCRIPTION
        Add a domain admin user account.

    .PARAMETER Domain
        Specify one or more domains for which the domain admin gets permission.

    .PARAMETER Username
        Set the username for the domain admin user account.

    .PARAMETER Password
        Set the password for the domain admin user account.

    .PARAMETER Enable
        Enable or disable the domain admin user account.

    .EXAMPLE
        New-MHDomainAdmin -Domain "example.com" -Username "AdminForExampleDotCom"

        This will create a new domain admin user account named "AdminForExampleDotCom" for the domain "example.com".
        The command will promp to enter a password.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Set the domain for which the domain user account should become an admin.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Set the username for the domain admin user account.")]
        [System.String]
        $Username,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Set the password for the domain admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the domain admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain-admin"
    }

    process {
        # Prepare the request body.
        $Body = @{
            domains   = $Domain
            username  = $Username
            password  = $Password | ConvertFrom-SecureString -AsPlainText
            password2 = $Password | ConvertFrom-SecureString -AsPlainText
            active    = "1"
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("domain admin user account [$Username].", "Add")) {
            Write-MailcowHelperLog -Message "Adding domain admin user account [$Username]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function New-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Add a blacklist or whitelist policy for a domain.

    .DESCRIPTION
        Add a blacklist or whitelist policy for a domain.

    .PARAMETER Domain
        The name of the domain for which to create the AntiSpam policy.
        Allows to specify multiple domain names.

    .PARAMETER From
        The from email address or domain.

    .PARAMETER ListType
        Add the specified from address either to the whitelist or blacklist.

    .EXAMPLE
        New-MHDomainAntiSpamPolicy -Domain "example.com" -From "spamexample.com" -ListType Blacklist

        Adds a blacklist entry for domain "example.com" for mails coming from "spamexample.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to get information for.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The from email address or domain.")]
        [System.String]
        $From,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "Add the specified from address either to the whitelist or blacklist.")]
        [ValidateSet("Whitelist", "Blacklist")]
        [System.String]
        $ListType
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/domain-policy/"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            $Body = @{
                domain      = $DomainItem
                object_from = $From
                object_list = switch ($ListType) {
                    "Whitelist" {
                        Write-MailcowHelperLog -Message "[$DomainItem] Adding address record to whitelist."
                        "wl"
                        break
                    }
                    "Blacklist" {
                        Write-MailcowHelperLog -Message "[$DomainItem] Adding address record to blacklist."
                        "bl"
                        break
                    }
                    default {
                        # Should never reach this point.
                        Write-MailcowHelperLog -Message "Unknown value for parameter "List"." -Level Error
                    }
                }
            }

            if ($PSCmdlet.ShouldProcess("domain anti-spam policy for domain [$DomainItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding domain anti-spam policy for domain [$DomainItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowHelperRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "Post"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-DomainTemplate {
    <#
    .SYNOPSIS
        Create a new domain template.

    .DESCRIPTION
        Create a new domain template.
        A domain template can either be specified as a default template for a new domain.
        Or you can select a template when creating a new mailbox to inherit some properties from the template.

    .PARAMETER Name
        The name of the domain template.

    .PARAMETER MaxNumberOfAliasesForDomain
        The maximum number of aliases allowed in a domain.

    .PARAMETER MaxNumberOfMailboxesForDomain
        The maximum number of mailboxes allowed in a domain.

    .PARAMETER DefaultMailboxQuota
        The default mailbox quota limit in MiB.

    .PARAMETER MaxMailboxQuota
        The maximum mailbox quota limit in MiB.

    .PARAMETER MaxDomainQuota
        The domain wide total maximum mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER DkimSelector
        The string to be used as DKIM selector.

    .PARAMETER DkimKeySize
        The DKIM key keysize.

    .PARAMETER Enable
        Enable or disable the domain created by the template.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain created by the template.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain created by the template.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain created by the template.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain created by the template.

    .EXAMPLE
        New-MHDomainTemplate -Name "MyDefaultDomainTemplate"

        Creates a domain template with the name "MyDefaultDomainTemplate". All values are set to mailcow defaults.

    .EXAMPLE
        New-MHDomainTemplate -Name "MyDefaultDomainTemplate" -MaxNumberOfAliasesForDomain 1000 -MaxNumberOfMailboxesForDomain 1000 -MaxDomainQuota 102400

        Creates a domain template with the name "MyDefaultDomainTemplate".
        The maximum number of aliases and mailboxes will be set to 1000. The domain wide total mailbox quota will be set to 100 GByte.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DefaultOptions")]
    param(
        [Parameter(ParametersetName = "DefaultOptions", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain template.")]
        [Parameter(ParametersetName = "IndividualSettings", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain template.")]
        [System.String]
        $Name,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The maximum number of aliases allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfAliasesForDomain = 400,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The maximum number of mailboxes allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfMailboxesForDomain = 10,

        [Parameter(ParametersetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "The default mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $DefaultMailboxQuota = 3072,

        [Parameter(ParametersetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "The maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxQuota = 10240,

        [Parameter(ParametersetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "The domain wide total maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxDomainQuota = 10240,

        [Parameter(ParametersetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter( ParametersetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(ParametersetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(ParametersetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "The string to be used as DKIM selector.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(ParametersetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "The DKIM key keysize.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $DkimKeySize = 2096,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly
    )

    # Prepare the base Uri path.
    $UriPath = "add/domain/template"

    # Prepare the request body.
    $Body = @{
        template = $Name.Trim()
    }
    if ($PSBoundParameters.ContainsKey("Tag")) {
        $Body.tags = $Tag
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxNumberOfAliasesForDomain")) {
        $Body.max_num_aliases_for_domain = $MaxNumberOfAliasesForDomain.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxNumberOfMailboxesForDomain")) {
        $Body.max_num_mboxes_for_domain = $MaxNumberOfMailboxesForDomain.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
        $Body.def_quota_for_mbox = $DefaultMailboxQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxMailboxQuota")) {
        $Body.max_quota_for_mbox = $MaxMailboxQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MaxDomainQuota")) {
        $Body.max_quota_for_domain = $MaxDomainQuota.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitValue")) {
        $Body.rl_value = $RateLimitValue.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitFrame")) {
        $Body.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DkimSelector")) {
        $Body.dkim_selector = $DkimSelector.Trim()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("DkimKeySize")) {
        $Body.key_size = $DkimKeySize.ToString()
    }
    if ($PSBoundParameters.ContainsKey("Enable")) {
        $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
    }
    if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
        $Body.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
    }
    if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
        $Body.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
    }
    if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
        $Body.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
    }
    if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
        $Body.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
    }

    if ($PSCmdlet.ShouldProcess("domain template [$($Name.Trim())].", "Add")) {
        Write-MailcowHelperLog -Message "Adding domain template [$($Name.Trim())]." -Level Information

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

        # Return the result.
        $Result
    }
}

function New-ForwardingHost {
    <#
    .SYNOPSIS
        Add one or more forwarding hosts to mailcow.

    .DESCRIPTION
        Add one or more forwarding hosts to mailcow.

    .PARAMETER Hostname
        The hostname or IP address of the forwarding host.

    .PARAMETER FilterSpam
        Enable or disable spam filter.

    .EXAMPLE
        New-MHForwardingHost -Hostname mail.example.com -FilterSpam

        This will resolve the hostname mail.example.com and add all ip addresses as forwarding host. Spam filter will be active for that host.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The Hostname or IP address of the forwarding host.")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Enable or disable spam filter.")]
        [System.Management.Automation.SwitchParameter]
        $FilterSpam
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/fwdhost"
    }

    process {
        foreach ($HostnameItem in $Hostname) {
            # Prepare the request body.
            $Body = @{
                hostname    = $HostnameItem
                filter_spam = if ($FilterSpam.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("forwarding host [$HostnameItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding forwarding host [$HostnameItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-Mailbox {
    <#
    .SYNOPSIS
        Add one or more mailboxes.

    .DESCRIPTION
        Add one or more mailboxes.

    .PARAMETER Identity
        The mail address for the new mailbox.

    .PARAMETER Name
        The name of the new mailbox. If ommited the local part of the mail address is used.

    .PARAMETER AuthSource
        The authentcation source to use. Default is "mailcow".

    .PARAMETER Password
        The password for the new mailbox user.

    .PARAMETER ActiveState
        The mailbox state. Valid values are:
        Active = Mails to the mail address are accepted, the account is enabled, so login is possible.
        DisallowLogin = Mails to the mail address are accepted, the account is disabled, so login is denied.
        Inactive = Mails to the mail address are rejected, the account is disabled, so login is denied.

    .PARAMETER MailboxQuota
        The mailbox quota in MB.
        If ommitted, the domain default mailbox quota will be applied.

    .PARAMETER Tag
        Add a tag that can be used for filtering

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections for this mailbox.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections from this mailbox.

    .PARAMETER Template
        The mailbox template to use.

    .EXAMPLE
        New-MHMailbox -Identity "user123@example.com" -Template "MyCustomMailboxTemplate"

        Creates a new mailbox for "user123@example.com". The mailbox is configured based on settings from a template.

    .EXAMPLE
        New-MHMailbox -Identity "user456@example.com" -ActiveState DisallowLogin

        Creates a new mailbox for "user456@example.com". The mailbox is set to disallow login.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address for the new mailbox.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox", "PrimaryAddress", "SmtpAddress")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The name of the new mailbox. If ommited the local part of the mail address is used.")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The authentcation source to use.")]
        [ValidateSet("mailcow", "Generic-OIDC", "Keycloak", "LDAP")]
        [System.String]
        $AuthSource = "mailcow",

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The password for the new mailbox user.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The mailbox state.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The mailbox quota in MB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Add a tag that can be used for filtering.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "The mailbox template to use.")]
        [System.String]
        $Template
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/mailbox"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Set name to the local part of th mail address, if it was not specified explicitly.
            if (-not $PSBoundParameters.ContainsKey("Name")) {
                $Name = $IdentityItem.User
            }

            # Prepare the request body.
            $Body = @{
                domain     = $IdentityItem.Host
                local_part = $IdentityItem.User
                password   = $Password | ConvertFrom-SecureString -AsPlainText
            }
            $Body.password2 = $Body.password

            if ($PSBoundParameters.ContainsKey("Name")) {
                if (-not [System.String]::IsNullOrEmpty($Name)) {
                    $Body.name = $Name.Trim()
                }
            }
            if ($PSBoundParameters.ContainsKey("AuthSource")) {
                if (-not [System.String]::IsNullOrEmpty($AuthSource)) {
                    $Body.authsource = $AuthSource.ToLower()
                }
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.quota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("ActiveState")) {
                $Body.active = "$($ActiveState.value__)"
            }
            if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
                $Body.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $Body.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $Body.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                if (-not [System.String]::IsNullOrEmpty($Tag)) {
                    $Body.tags = $Tag
                }
            }
            if ($PSBoundParameters.ContainsKey("Template")) {
                # If no template is specified, the API will use values from the default maibox template for values that have not been explicitly specified otherwise.
                if (-not [System.String]::IsNullOrEmpty($Template)) {
                    $Body.template = $Template
                }
            }

            if ($PSCmdlet.ShouldProcess("mailbox [$IdentityItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding mailbox [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-MailboxTemplate {
    <#
    .SYNOPSIS
        Create a new mailbox template.

    .DESCRIPTION
        Create a new mailbox template.
        A mailbox template can either be specified as a default template for a domain.
        Or you can select a template when creating a new mailbox to inherit some properties from the template.

    .PARAMETER Name
        The name of the mailbox template.

    .PARAMETER MailboxQuota
        The mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER TaggedMailHandler
        The action to execute for tagged mail.

    .PARAMETER QuarantineNotification
        The notification interval.

    .PARAMETER QuarantineCategory
        The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER ActiveState
        The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections for this mailbox.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections from this mailbox.

    .PARAMETER SogoAccess
        Enable or disable access to SOGo for the user.

    .PARAMETER ImapAccess
        Enable or disable IMAP for the user.

    .PARAMETER Pop3Access
        Enable or disable POP3 for the user.

    .PARAMETER SmtpAccess
        Enable or disable SMTP for the user.

    .PARAMETER SieveAccess
        Enable or disable Sieve for the user.

    .PARAMETER EasAccess
        Enable or disable Exchange Active Sync for the user.

    .PARAMETER DavAccess
        Enable or disable CalDAV/CardDav for the user.

    .PARAMETER AclManageAppPassword
        Allow to manage app passwords.

    .PARAMETER AclDelimiterAction
        Allow Delimiter Action.

    .PARAMETER AclResetEasDevice
        Allow to reset EAS device.

    .PARAMETER AclPushover
        Allow Pushover.

    .PARAMETER AclQuarantineAction
        Allow quarantine action.

    .PARAMETER AclQuarantineAttachment
        Allow quarantine attachement.

    .PARAMETER AclQuarantineNotification
        Allow to change quarantine notification.

    .PARAMETER AclQuarantineNotificationCategory
        Allow to change quarantine notification category.

    .PARAMETER AclSOGoProfileReset
        Allow to reset the SOGo profile.

    .PARAMETER AclTemporaryAlias
        Allow to manage temporary alias.

    .PARAMETER AclSpamPolicy
        Allow to manage SPAM policy.

    .PARAMETER AclSpamScore
        Allow to manage SPAM score.

    .PARAMETER AclSyncJob
        Allow to manage sync job.

    .PARAMETER AclTlsPolicy
        Allow to manage TLS policy.

    .PARAMETER AclPasswordReset
        Allow to reset the user password.

    .EXAMPLE
        New-MHMailboxTemplate -Name "ExampleTemplate"

        This creates a new mailbox template using default values for all parameters.

    .EXAMPLE
        New-MHMailboxTemplate -Name "ExampleTemplate" -MailboxQuota 10240 -RateLimitValue 5 -RateLimitFrame Minute

        This creates a new mailbox template allowing a maximum of 10 GByte per mailbox and allowing maximum of 5 mails per minute.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DefaultOptions")]
    param(
        [Parameter(ParametersetName = "DefaultOptions", Position = 0, Mandatory = $true, HelpMessage = "The name of the mailbox template.")]
        [Parameter(ParametersetName = "IndividualSettings", Position = 0, Mandatory = $true, HelpMessage = "The name of the mailbox template.")]
        [System.String]
        $Name,

        [Parameter(ParametersetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "The mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(ParametersetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter(ParametersetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "The action to execute for tagged mail.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailHandler = "Nothing",

        [Parameter(ParametersetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuarantineNotification = "Hourly",

        [Parameter(ParametersetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuarantineCategory = "Rejected",

        [Parameter( ParametersetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(ParametersetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(ParametersetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState = "Active",

        [Parameter(ParametersetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(ParametersetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(ParametersetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(ParametersetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(ParametersetName = "IndividualSettings", Position = 15, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 16, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 17, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(ParametersetName = "IndividualSettings", Position = 18, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 19, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AclManageAppPassword,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 20, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $AclDelimiterAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 21, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $AclResetEasDevice,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 22, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $AclPushover,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 23, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 24, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAttachment,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 25, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotification,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 26, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotificationCategory,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 27, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $AclSOGoProfileReset,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 28, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $AclTemporaryAlias,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 29, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 30, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamScore,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 31, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $AclSyncJob,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 32, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclTlsPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 33, Mandatory = $false, HelpMessage = "Allow to reset the user password.")]
        [System.Management.Automation.SwitchParameter]
        $AclPasswordReset
    )

    # Prepare the base Uri path.
    $UriPath = "add/mailbox/template"

    # Prepare the request body.
    $Body = @{
        template        = $Name.Trim()
        protocol_access = [System.Collections.ArrayList]@()
        acl             = [System.Collections.ArrayList]@()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("MailboxQuota")) {
        $Body.quota = $MailboxQuota.ToString()
    }
    if ($PSBoundParameters.ContainsKey("Tag")) {
        $Body.tags = $Tag
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("TaggedMailHandler")) {
        $Body.tagged_mail_handler = $TaggedMailHandler.ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("QuarantineNotification")) {
        $Body.quarantine_notification = $QuarantineNotification.ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("QuarantineCategory")) {
        $Body.quarantine_category = switch ($QuarantineCategory) {
            "Rejected" {
                "reject"
                break
            }
            "Junk folder" {
                "add_header"
                break
            }
            default {
                # "All categories"
                "all"
            }
        }
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitValue")) {
        $Body.rl_value = $RateLimitValue.ToString()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("RateLimitFrame")) {
        $Body.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
    }
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions" -or $PSBoundParameters.ContainsKey("ActiveState")) {
        $Body.active = "$($ActiveState.value__)"
    }

    # Set some default options.
    if ($PSCmdlet.ParameterSetName -eq "DefaultOptions") {
        $EnforceTlsIn = $false
        $EnforceTlsOut = $false
        $ForcePasswordUpdate = $false
        $SogoAccess = $true

        $ImapAccess = $true
        $Pop3Access = $true
        $SmtpAccess = $true
        $SieveAccess = $true
        $EasAccess = $false
        $DavAccess = $true

        $AclManageAppPassword = $true
        $AclDelimiterAction = $true
        $AclResetEasDevice = $true
        $AclPushover = $true
        $AclQuarantineAction = $true
        $AclQuarantineAttachment = $true
        $AclQuarantineNotification = $true
        $AclQuarantineNotificationCategory = $true
        $AclSOGoProfileReset = $false
        $AclTemporaryAlias = $true
        $AclSpamPolicy = $true
        $AclSpamScore = $true
        $AclSyncJob = $false
        $AclTlsPolicy = $true
        $AclPasswordReset = $true
    }

    if ($EnforceTlsIn.IsPresent) {
        $Body.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
    }
    if ($EnforceTlsOut.IsPresent) {
        $Body.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
    }
    if ($ForcePasswordUpdate.IsPresent) {
        $Body.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
    }
    if ($SogoAccess.IsPresent) {
        $Body.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
    }
    if ($ImapAccess.IsPresent) {
        $null = $Body.protocol_access.Add("imap")
    }
    if ($Pop3Access.IsPresent) {
        $null = $Body.protocol_access.Add("pop3")
    }
    if ($SmtpAccess.IsPresent) {
        $null = $Body.protocol_access.Add("smtp")
    }
    if ($SieveAccess.IsPresent) {
        $null = $Body.protocol_access.Add("sieve")
    }
    if ($EasAccess.IsPresent) {
        $null = $Body.protocol_access.Add("eas")
    }
    if ($DavAccess.IsPresent) {
        $null = $Body.protocol_access.Add("dav")
    }

    if ($AclManageAppPassword.IsPresent) {
        $null = $Body.acl.Add("app_passwds")
    }
    if ($AclDelimiterAction.IsPresent) {
        $null = $Body.acl.Add("delimiter_action")
    }
    if ($AclResetEasDevice.IsPresent) {
        $null = $Body.acl.Add("eas_reset")
    }
    if ($AclPushover.IsPresent) {
        $null = $Body.acl.Add("pushover")
    }
    if ($AclQuarantineAction.IsPresent) {
        $null = $Body.acl.Add("quarantine")
    }
    if ($AclQuarantineAttachment.IsPresent) {
        $null = $Body.acl.Add("quarantine_attachments")
    }
    if ($AclQuarantineNotification.IsPresent) {
        $null = $Body.acl.Add("quarantine_notification")
    }
    if ($AclQuarantineNotificationCategory.IsPresent) {
        $null = $Body.acl.Add("quarantine_category")
    }
    if ($AclSOGoProfileReset.IsPresent) {
        $null = $Body.acl.Add("sogo_profile_reset")
    }
    if ($AclTemporaryAlias.IsPresent) {
        $null = $Body.acl.Add("spam_alias")
    }
    if ($AclSpamPolicy.IsPresent) {
        $null = $Body.acl.Add("spam_policy")
    }
    if ($AclSpamScore.IsPresent) {
        $null = $Body.acl.Add("spam_score")
    }
    if ($AclSyncJob.IsPresent) {
        $null = $Body.acl.Add("syncjobs")
    }
    if ($AclTlsPolicy.IsPresent) {
        $null = $Body.acl.Add("tls_policy")
    }
    if ($AclPasswordReset.IsPresent) {
        $null = $Body.acl.Add("pw_reset")
    }

    if ($PSCmdlet.ShouldProcess("mailbox template [$($Name.Trim())].", "Add")) {
        Write-MailcowHelperLog -Message "Adding mailbox template [$($Name.Trim())]." -Level Information

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

        # Return the result.
        $Result
    }
}

function New-MtaSts {
    <#
    .SYNOPSIS
        Add a MTS-STS policy for the specified domain.

    .DESCRIPTION
        Add a MTS-STS policy for the specified domain.
        There can only be one MTA-STS policy per domain.
        Refer to the mailcow documentation for more information.

    .PARAMETER Domain
        The name of the domain for which to add a MTA-STS policy.

    .PARAMETER Version
        The MTA-STS version. Only STSv1 is available.

    .PARAMETER Mode
        The MTA-STS mode to use. Valid options are:
        Enforce, Testing, None

    .PARAMETER MxServer
        The MxServer to use.

    .PARAMETER MaxAge
        Time in seconds that receiving mail servers may cache this policy until refetching.

    .EXAMPLE
        New-MHMtaSts -Domain "example.com" -Mode Enforce -MxServer 1.2.3.4, 5.6.7.8

        Add a MTA-STS policy for domain "example.com" in enforce mode with two MX servers.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-MtaSts.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to add a MTA-STS policy.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The STS version.")]
        [ValidateSet("STSv1")]
        [System.String]
        $Version = "STSv1",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The MTA-STS mode to use.")]
        [ValidateSet("Enforce", "Testing", "None")]
        [System.String]
        $Mode = "Enforce",

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The MxServer to use.")]
        [System.String[]]
        $MxServer,

        [Parameter(Position = 4, Mandatory = $true, HelpMessage = "Time in seconds that receiving mail servers may cache this policy until refetching.")]
        [ValidateRange(1, 31536000)]
        [System.Int32]
        $MaxAge = 86400 # 86400 seconds = 1 day
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/mta-sts"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = @{
                domain  = $DomainItem.Trim().ToLower()
                version = $Version.ToLower()
                mode    = $Mode.ToLower()
                mx      = $MxServer -join ","
                max_age = $MaxAge
            }

            Write-MailcowHelperLog -Message "This function just adds a policy. But you must manually enable it in the mailcow admin UI because it is not possible to do this via the API." -Level Warning

            if ($PSCmdlet.ShouldProcess("domain mta-sts for domain [$($DomainItem.Trim())].", "Add")) {
                Write-MailcowHelperLog -Message "Adding domain mta-sts for domain [$($DomainItem.Trim())]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-OauthClient {
    <#
    .SYNOPSIS
        Add an OAuth client to the mailcow server.

    .DESCRIPTION
        Add an OAuth client to the mailcow server.

    .PARAMETER RedirectUri
        The redirect URI for the new OAuth client.

    .EXAMPLE
        New-MHOauthClient -RedirectUri "https://localhost:12345"

        Creates a new OAuth client with the specified redirect URI.

    .INPUTS
        System.Uri[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, Helpmessage = "The redirect URI for the new OAuth client.")]
        [System.Uri[]]
        $RedirectUri
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/oauth2-client"
    }

    process {
        foreach ($RedirectUriItem in $RedirectUri) {
            # Prepare the request body.
            $Body = @{
                redirect_uri = $RedirectUriItem.AbsoluteUri
            }

            if ($PSCmdlet.ShouldProcess("Oauth client [$($RedirectUriItem.AbsoluteUri)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding Oauth client [$($RedirectUriItem.AbsoluteUri)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-Resource {
    <#
    .SYNOPSIS
        Adds one or more resource accounts on a mailcow server.

    .DESCRIPTION
        Adds one or more resource accounts on a mailcow server.

    .PARAMETER Name
        The name of the new resource account. Will be used as the user part for the mail address.

    .PARAMETER Domain
        The domain in which the resource account should be created.

    .PARAMETER Type
        The resource type.

    .PARAMETER BookingShowBusyWhenBooked
        Show busy when resource is booked.

    .PARAMETER BookingShowAlwaysFree
        Show resource always as free.

    .PARAMETER BookingCustomLimit
        Allow the specified number of bookings only.

    .PARAMETER Enable
        Enable or disable the resource account.

    .EXAMPLE
        New-MHResource

        Returns all resource accounts on a mailcow server.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "BookingShowBusyWhenBooked", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the new resource account. Will be used as the user part for the mail address.")]
        [System.String[]]
        $Name,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The domain in which the resource account should be created.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $Domain,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The resource type.")]
        [ValidateSet("Location", "Group", "Thing")]
        [System.String]
        $Type,

        [Parameter(ParameterSetName = "BookingShowBusyWhenBooked", Position = 3, Mandatory = $false, HelpMessage = "Show busy when resource is booked.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowBusyWhenBooked,

        [Parameter(ParameterSetName = "BookingShowAlwaysFree", Position = 3, Mandatory = $false, HelpMessage = "Show resource always as free.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowAlwaysFree,

        [Parameter(ParameterSetName = "BookingCustomLimit", Position = 3, Mandatory = $false, HelpMessage = "Allow the specified number of bookings only.")]
        [System.int32]
        $BookingCustomLimit,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the resource account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/resource"
    }

    process {
        foreach ($NameItem in $Name) {
            # Prepare the request body.
            $Body = @{
                description       = $Name.Trim()
                domain            = $Domain
                kind              = $Type.ToLower()
                active            = "1"

                # -1 soft limit, show busy when booked
                #  0 always free
                # >0 hard limit, number -eq limit
                # Set it to "show busy when booked" by default. Change later based on the parameter values.
                multiple_bookings = "-1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("BookingShowBusyWhenBooked")) {
                $Body.multiple_bookings = if ($BookingShowBusyWhenBooked.IsPresent) { "-1" }
            }
            if ($PSBoundParameters.ContainsKey("BookingShowAlwaysFree")) {
                $Body.multiple_bookings = if ($BookingShowAlwaysFree.IsPresent) { "0" }
            }
            if ($PSBoundParameters.ContainsKey("BookingCustomLimit")) {
                $Body.multiple_bookings = $BookingCustomLimit
            }

            if ($PSCmdlet.ShouldProcess("resource [$NameItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding resource [$NameItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-RoutingRelayHost {
    <#
    .SYNOPSIS
        Creates a relay host (sender-dependent transport) configuration on the mailcow server.

    .DESCRIPTION
        Creates a relay host (sender-dependent transport) configuration on the mailcow server.

        Define sender-dependent transports which can be set in a domains configuration.
        The transport service is always "smtp:" and will therefore try TLS when offered. Wrapped TLS (SMTPS) is not supported.
        A users individual outbound TLS policy setting is taken into account.
        Affects selected domains including alias domains.

    .PARAMETER Hostname
        The hostname of the relay host

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the relay host.

    .PARAMETER Password
        The password for the login on the relay host.

    .PARAMETER Enable
        Enable or disable the relay host.

    .EXAMPLE
        New-MHRoutingRelayHost -Hostname "mail.example.com" -Username "user123@example.com"

        Add relay host "mail.example.com" with username "User123". The password will be requested interactivly.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The hostname of the relay host")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The username for the login on the relay host.")]
        [System.String]
        $Username,

        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The password for the login on the relay host.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Enable or disable the relay host.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/relayhost"
    }

    process {
        foreach ($HostnameItem in $Hostname) {
            # Prepare the request body.
            $Body = @{
                hostname = $HostnameItem.Trim().ToLower() + ":" + $Port.ToString()
                username = $Username.Trim()
                password = $Password | ConvertFrom-SecureString -AsPlainText
                # By default enable the new item.
                active   = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("relay host [$($HostnameItem.Trim())].", "Add")) {
                Write-MailcowHelperLog -Message "Adding relay host [$($HostnameItem.Trim())]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-RoutingTransport {
    <#
    .SYNOPSIS
        Create a transport map configuration.

    .DESCRIPTION
        Create a transport map configuration.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).
s
    .PARAMETER Destination
        The destination domain. Accepts regex.

    .PARAMETER Hostname
        The hostname for the next hop to the destination.

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the routing server.

    .PARAMETER Password
        The password for the destination server.

    .PARAMETER IsMxBased
        Enable or disable MX lookup for the transport rule.

    .PARAMETER Enable
        Enable or disable the transport rule.

    .EXAMPLE
        New-MHRoutingTransport -Domain "example.com" -Hostname "next.hop.to.example.mail" -Username "user123"

        Creates a transport rule for domain "example.com" using "next.hop.to.example.mail" as next hop. The password for the specified user will be requested interactivly on execution.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The destination domain. Accepts regex.")]
        [System.String[]]
        $Destination,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The hostname for the next hop to the destination.")]
        [System.String]
        $Hostname,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The username for the login on the routing server.")]
        [System.String]
        $Username,

        [Parameter(Position = 4, Mandatory = $true, HelpMessage = "The password for the login on the destination server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable MX lookup for the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $IsMxBased,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Enable or disable the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/transport"
    }

    process {
        foreach ($DestinationItem in $Destination) {
            # Prepare the request body.
            $Body = @{
                destination = $DestinationItem.Trim().ToLower()
                nexthop     = $Hostname.Trim().ToLower() + ":" + $Port.ToString()
                username    = $Username.Trim()
                password    = $Password | ConvertFrom-SecureString -AsPlainText
                # By default enable the new item.
                active      = "1"
                # By default disable mx lookup.
                is_mx_based = "0"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("IsMxBased")) {
                $Body.is_mx_based = if ($IsMxBased.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mail transport", "add item")) {
                Write-MailcowHelperLog -Message "Adding mail transport for destination [$($DestinationItem.Trim())] with next hop [$($Hostname.Trim())]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-RspamdSetting {
    <#
    .SYNOPSIS
        Creates a new Rspamd rule.

    .DESCRIPTION
        Creates a new Rspamd rule.

    .PARAMETER Content
        The script content for the new Rspamd rule.

    .PARAMETER Description
        A description for the new Rspamd rule.

    .PARAMETER Enable
        Enalbe or disable the new Rspamd rule.

    .EXAMPLE
        New-MHRspamdSetting -Content $(Get-Content -Path .\rule.txt) -Description "My new rule" -Enable:$false

        Creates a new Rspamd rule with content read from ".\rule.txt" file. The rule will be disabled.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The script content for the new Rspamd rule.")]
        [System.String]
        $Content,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A description for the new Rspamd rule.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enalbe or disable the new Rspamd rule.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/rsetting"
    }

    process {
        # Prepare the request body.
        $Body = @{
            content = $Content
            # By default enable new item.
            active  = "1"
        }
        if ($PSBoundParameters.ContainsKey("Description")) {
            $Body.desc = $Description
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("Rspamd rule", "Add")) {
            Write-MailcowHelperLog -Message "Adding mailcow Rspamd rule." -Level Information
            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $UriPath -Method Post -Body $Body

            if ($null -ne $Result -and $Result.type -eq "success") {
                Write-Warning -Message "Rspamd setting added. Please note that the specified content can not be validated. Make sure to use correct syntax. Follow documentation like on https://docs.rspamd.com/tutorials/settings_guide/."
            }
            # Return the result.
            $Result
        }
    }
}

function New-SieveFilter {
    <#
    .SYNOPSIS
        Create a new admin defined Sieve filter for one or more mailboxes.

    .DESCRIPTION
        Create a new admin defined Sieve filter for one or more mailboxes.
        Note that filter definitions created by this function/API call will only show up in the admin GUI (E-Mail / Configuration / Filters).
        A user will not see this filter in SOGo.

    .PARAMETER Identity
        The mail address of the mailbox for which to create a filter script.

    .PARAMETER FilterType
        Either PreFilter or PostFilter.

    .PARAMETER Description
        A description for the new sieve filter script.

    .PARAMETER SieveScriptContent
        The Sieve script.

    .PARAMETER Enable
        Enable or disable the new filter script.

    .EXAMPLE
        New-MHSieveFilter -Identity "user1@example.com" -FilterType PreFilter -Description "A new filter" -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)

        Creates a new prefilter filter script for user "user1@example.com". The script is loaded from text file ".\PreviouslySavedScript.txt".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to create a filter script.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateSet("PreFilter", "PostFilter")]
        [System.String]
        $FilterType,

        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter(Position = 3, Mandatory = $true)]
        [System.String]
        $SieveScriptContent,

        [Parameter(Position = 4, Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/filter"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

            # Prepare the request body.
            $Body = @{
                # Set the values that are either mandatory parameters or have a default parameter value.
                username    = $IdentityItem.Address
                filter_type = $FilterType.ToLower()
                script_desc = $Description.Trim()
                script_data = $SieveScriptContent.Trim()

                # Set some default values. These might be overwritten later, depending on what parameters have been specified.
                active      = "1"
            }

            # Set values based on what was provided by parameters.
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mailbox sieve filter for [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding mailbox sieve filter for [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-SyncJob {
    <#
    .SYNOPSIS
        Add a new sync job for a mailbox.

    .DESCRIPTION
        Add a new sync job for a mailbox.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to create a sync job.

    .PARAMETER Hostname
        The hostname of the remote mail server from where to sync.

    .PARAMETER Port
        The IMAP port number on the remote mail server.

    .PARAMETER Username
        The username for the login on the remote mail server.

    .PARAMETER Password
        The password for the login on the remote mail server.

    .PARAMETER Encryption
        The type of encryption to use for the remote mail server.

    .PARAMETER Interval
        Interval in minutes for checking the remote mailbox.

    .PARAMETER TargetSubfolder
        The name of the folder to where the remote folder should be synced.

    .PARAMETER MaxAge
        Maximum age of messages in days that will be polled from remote (0 = ignore age).

    .PARAMETER MaxBytesPerSecond
        Max. bytes per second (0 = unlimited).

    .PARAMETER TimeoutRemoteHost
        Timeout for connection to remote host (seconds).

    .PARAMETER TimeoutLocalHost
        Timeout for connection to local host (seconds).

    .PARAMETER ExcludeObjectsRegex
        Exclude objects (regex).

    .PARAMETER CustomParameter
        Example: --some-param=xy --other-param=yx

    .PARAMETER DeleteDuplicatesOnDestination
        Delete duplicates on destination (--delete2duplicates). Default is enabled.

    .PARAMETER DeleteFromSourceWhenCompleted
        Delete from source when completed (--delete1). Default is disabled.

    .PARAMETER DeleteMessagesOnDestinationThatAreNotOnSource
        Delete messages on destination that are not on source (--delete2). Default is disabled.

    .PARAMETER AutomapFolders
        Try to automap folders ("Sent items", "Sent" => "Sent" etc.) (--automap). Default is enabled.

    .PARAMETER SkipCrossDuplicates
        Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.

    .PARAMETER SubscribeAll
        Subscribe all folders (--subscribeall). Default is enabled.

    .PARAMETER SimulateSync
        Simulate synchronization (--dry). Default is enabled.

    .PARAMETER Enable
        Enable or disable the sync job.

    .EXAMPLE
        New-MHSyncJob -Mailbox "user1@example.com" -Hostname "mail.anotherexample.com" -Username "user@mail.anotherexample.com" -Verbose

        Creates a new sync job for user "user1@example.com" getting mail from "mail.anotherexample.com".
        The login name for the remote mailbox is set to "user@mail.anotherexample.com". The password will be requested to enter interactively.

    .INPUTS
        System.Net.Mail.MailAddress

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to create a sync job.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress]
        $Identity,

        [Parameter(Mandatory = $true, HelpMessage = "The hostname of the remote mail server from where to sync.")]
        [System.String]
        $Hostname,

        [Parameter(Mandatory = $false, HelpMessage = "The IMAP port number on the remote mail server.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 993,

        [Parameter(Mandatory = $true, HelpMessage = "The username for the login on the remote mail server.")]
        [System.Net.Mail.MailAddress]
        $Username,

        [Parameter(Mandatory = $true, HelpMessage = "The password for the login on the remote mail server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Mandatory = $false, HelpMessage = "The type of encryption to use for the remote mail server.")]
        [ValidateSet("TLS", "SSL", "PLAIN")]
        [System.String]
        $Encryption = "TLS",

        [Parameter(Mandatory = $false, HelpMessage = "Interval in minutes for checking the remote mailbox.")]
        [ValidateRange(0, 43800)]
        [System.Int32]
        $Interval = 20,

        [Parameter(Mandatory = $false, HelpMessage = "The name of the folder to where the remote folder should be synced.")]
        [System.String]
        $TargetSubfolder,

        [Parameter(Mandatory = $false, HelpMessage = "Maximum age of messages in days that will be polled from remote (0 = ignore age).")]
        [ValidateRange(0, 32000)]
        [System.Int32]
        $MaxAge = 0,

        [Parameter(Mandatory = $false, HelpMessage = "Max. bytes per second (0 = unlimited).")]
        [ValidateRange(0, 125000000)]
        [System.Int32]
        $MaxBytesPerSecond = 0,

        [Parameter( Mandatory = $false, HelpMessage = "Timeout for connection to remote host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutRemoteHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Timeout for connection to local host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutLocalHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Exclude objects (regex).")]
        [System.String]
        $ExcludeObjectsRegex = "(?i)spam|(?i)junk",

        [Parameter(Mandatory = $false, HelpMessage = "Example: --some-param=xy --other-param=yx")]
        [System.String]
        $CustomParameter,

        [Parameter(Mandatory = $false, Helpmessage = "Delete duplicates on destination (--delete2duplicates). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteDuplicatesOnDestination,

        [Parameter(Mandatory = $false, Helpmessage = "Delete from source when completed (--delete1). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteFromSourceWhenCompleted,

        [Parameter(Mandatory = $false, Helpmessage = "Delete messages on destination that are not on source (--delete2). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteMessagesOnDestinationThatAreNotOnSource,

        [Parameter(Mandatory = $false, Helpmessage = "Try to automap folders ('Sent items', 'Sent' => 'Sent' etc.) (--automap). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $AutomapFolders,

        [Parameter(Mandatory = $false, Helpmessage = "Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCrossDuplicates,

        [Parameter( Mandatory = $false, Helpmessage = "Subscribe all folders (--subscribeall). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SubscribeAll,

        [Parameter(Mandatory = $false, Helpmessage = "Simulate synchronization (--dry). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SimulateSync,

        [Parameter(Mandatory = $false, HelpMessage = "Enable or disable the sync job.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/syncjob"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = @{
                # Set the values that are either mandatory parameters or have a default parameter value.
                username            = $IdentityItem.Address
                host1               = $Hostname
                port1               = $Port.ToString()
                user1               = $Username.Address
                password1           = $Password | ConvertFrom-SecureString -AsPlainText
                enc1                = $Encryption.ToUpper() # must be upper case, because otherwise "access_denied" is returned.
                mins_interval       = $Interval.ToString()
                maxage              = $MaxAge.ToString()
                maxbytespersecond   = $MaxBytesPerSecond.ToString()
                timeout1            = $TimeoutRemoteHost.ToString()
                timeout2            = $TimeoutLocalHost.ToString()
                exclude             = $ExcludeObjectsRegex

                # Set some default values. These might be overwritten later, depending on what parameters have been specified.
                active              = "1"
                delete2duplicates   = "1"
                delete1             = "0"
                delete2             = "0"
                automap             = "1"
                skipcrossduplicates = "0"
                subscribeall        = "1"
                dry                 = "1"
            }

            # Set values based on what was provided by parameters.
            if ($PSBoundParameters.ContainsKey("TargetSubfolder")) {
                $Body.subfolder2 = $TargetSubfolder.Trim()
            }
            if ($PSBoundParameters.ContainsKey("CustomParameter")) {
                $Body.custom_params = $CustomParameter.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("DeleteDuplicatesOnDestination")) {
                $Body.delete2duplicates = if ($DeleteDuplicatesOnDestination.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("DeleteFromSourceWhenCompleted")) {
                $Body.delete1 = if ($DeleteFromSourceWhenCompleted.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("DeleteMessagesOnDestinationThatAreNotOnSource")) {
                $Body.delete2 = if ($DeleteMessagesOnDestinationThatAreNotOnSource.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("AutomapFolders")) {
                $Body.automap = if ($AutomapFolders.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SkipCrossDuplicates")) {
                $Body.skipcrossduplicates = if ($SkipCrossDuplicates.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SubscribeAll")) {
                $Body.subscribeall = if ($SubscribeAll.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SimulateSync")) {
                $Body.dry = if ($SimulateSync.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("Sync job for [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding sync job for [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function New-TlsPolicyMap {
    <#
    .SYNOPSIS
        Create a new TLS policy map override.

    .DESCRIPTION
        Create a new TLS policy map override.

    .PARAMETER Domain
        The destination domain name.

    .PARAMETER Policy
        Policy to use. Valid options are:
        None, May, Encrypt, Dane, Dane-Only, Fingerprint, Verify, Secure

    .PARAMETER Parameter
        Specify additional parameters.
        Example: "protocols=!SSLv2 ciphers=medium exclude=3DES"

    .PARAMETER Enable
        Enable or disable the TLS policy map override.

    .EXAMPLE
        New-MHTlsPolicyMap -Destination "example.com" -Policy Encrypt

        Creates a new TLS policy map override for the destination domain "exmaple.com" using the "Encrypt" policy.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The destination domain name.")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Policy to use.")]
        [ValidateSet("None", "May", "Encrypt", "Dane", "Dane-Only", "Fingerprint", "Verify", "Secure")]
        [System.String]
        $Policy = "Encrypt",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Specify additional parameters.")]
        [System.String]
        $Parameter,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the TLS policy map override.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/tls-policy-map"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = @{
                dest       = $DomainItem.Trim().ToLower()
                policy     = $Policy.Trim().ToLower()
                parameters = $Parameter.ToLower()
                active     = "1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("TLS policy map override for [$($DomainItem.Trim())].", "Add")) {
                Write-MailcowHelperLog -Message "Adding TLS policy map override for [$($DomainItem.Trim())]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Removes a BCC map.

    .DESCRIPTION
        Removes a BCC map.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Id
        Id number of BCC map to remove.

    .EXAMPLE
        Remove-MHAddressRewriteBccMap -Id 1

        Removes BCC map with ID 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Id number of BCC map to remove.")]
        [Alias("BccMapId")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/bcc"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem.ToString()

            # Get BCC map information for logging.
            $CurrentBccMapConfig = Get-AddressRewriteBccMap -Id $IdItem

            if ($PSCmdlet.ShouldProcess("BCC map [$($CurrentBccMapConfig.id)]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting rule ID [$($CurrentBccMapConfig.id)], Address: [$($CurrentBccMapConfig.local_dest)], BCC destionation to [$($CurrentBccMapConfig.bcc_dest)], map type [$($CurrentBccMapConfig.type)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Remove a recipient map.

    .DESCRIPTION
        Remove a recipient map.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER Id
        Id number of recipient map to remove.

    .EXAMPLE
        Remove-MHAddressRewriteRecipientMap -Id 15

        Removes recipient map with id 15.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Id number of recipient map to remove.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/recipient_map"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem.ToString()

            # Get BCC map configuration for logging.
            $CurrentBccMapConfig = Get-AddressRewriteRecipientMap -Identity $IdItem

            if ($PSCmdlet.ShouldProcess("BCC map [$($CurrentBccMapConfig.id)]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting rule ID [$($CurrentBccMapConfig.id)], TargetAddress: [$($CurrentBccMapConfig.recipient_map_old)], redirected to [$($CurrentBccMapConfig.recipient_map_new)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-Admin {
    <#
    .SYNOPSIS
        Removes an admin user account.

    .DESCRIPTION
        Removes an admin user account.

    .PARAMETER Identity
        The login name for the new admin user account.

    .EXAMPLE
        Remove-MHAdmin -Identity "cowboy"

        This will remove the admin user account named "cowboy" after confirming to do so.

    .EXAMPLE
        Remove-MHAdmin -Identity "cowboy" -Confirm:$false

        This will remove the admin user account named "cowboy" without confirming.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Identity of the admin user account to remove.")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $Identity

            if ($PSCmdlet.ShouldProcess("mailcow admin [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailcow admin [$IdentityItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }
            # Return the result.
            $Result
        }
    }
}

function Remove-AliasDomain {
    <#
    .SYNOPSIS
        Removes an alias domain.

    .DESCRIPTION
        Removes an alias domain.

    .PARAMETER Identity
        The alias domain name.

    .EXAMPLE
        Remove-MHAliasDomain -Identity "alias.example.com"

        Remove the alias domain "alias.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias domain name.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Check if the specified alias exists. Show warning in case it does not.
            $CurrentAliasDomain = Get-AliasDomain -Identity $IdentityItem

            if ($null -eq $CurrentAliasDomain) {
                # Show warning about non-existent alias-domain.
                Write-MailcowHelperLog -Message "[$($IdentityItem.Trim().ToLower())] Alias not found!" -Level Warning
            }
            else {
                # Prepare the request body.
                $Body = $IdentityItem.Trim().ToLower()

                if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "Delete")) {
                    Write-MailcowHelperLog -Message "Deleting alias domain [$IdentityItem]."

                    # Execute the API call.
                    $InvokeMailcowApiRequestParams = @{
                        UriPath = $UriPath
                        Method  = "POST"
                        Body    = $Body
                    }
                    $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                    # Return the result.
                    $Result
                }
            }
        }
    }
}

function Remove-AliasMail {
    <#
    .SYNOPSIS
        Removes one or more mail aliases.

    .DESCRIPTION
        Removes one or more mail aliases.

    .PARAMETER Identity
        The alias mail address to remove.

    .EXAMPLE
        Remove-MHMailAlias -Identity alias@example.com

        Removes alias@example.com.

    .EXAMPLE
        Get-MHMailAlias -Identity "alias@example.com" | Remove-MHMailAlias

        Removes alias@example.com by piping the output of Get-AliasMail to Remove-MHMailAlias.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias mail address to remove.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Get the id value of each individual alias. This allows to check if the alias exists and show warning in case it does not.
            $AliasId = Get-AliasMail -Identity $IdentityItem.Address
            if ($null -eq $AliasId) {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Alias not found!" -Level Warning
            }
            else {
                Write-MailcowHelperLog -Message "[$($IdentityItem.Address)] Deleting alias with id [$($AliasId.id)]."
            }

            # Prepare the request body.
            $Body = $AliasId.id

            if ($PSCmdlet.ShouldProcess("alias [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting alias [$($IdentityItem.Address)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }
            # Return the result.
            $Result
        }
    }
}

function Remove-AliasTimeLimited {
    <#
    .SYNOPSIS
        Removes one or more time-limited alias (spamalias).

    .DESCRIPTION
        Removes one or more time-limited alias (spamalias).

    .PARAMETER Identity
        The time-limited alias addresss to delete.

    .EXAMPLE
        Remove-MHAliasTimeLimited -Identity "alias@example.com"

        Deletes the alias "alias@example.com"

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = " The time-limited alias addresss to delete.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/time_limited_alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("time-limited alias [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting time-limited alias [$($IdentityItem.Address)] ."

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-AppPassword {
    <#
    .SYNOPSIS
        Deletes one or more appliation-specific passwords.

    .DESCRIPTION
        Deletes one or more appliation-specific passwords.

    .PARAMETER Id
        The app password id.

    .EXAMPLE
        Remove-MHAppPassword -Identity 17

        Deletes app password with ID 17.

    .EXAMPLE
        Get-AppPassword -Identity "user1@example.com" | Remove-MHAppPassword

        Deletes all app passwords configured for the mailbox of "user1@example.com".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The app password id.")]
        [Alias("AppPasswordId")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/app-passwd"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("app password id [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting app password id [$($Id -join ",")].." -Level Warning

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Remove-DkimKey {
    <#
    .SYNOPSIS
        Deletes a DKIM key for one or more domains.

    .DESCRIPTION
        Deletes a DKIM key for one or more domains.

    .PARAMETER Domain
        The name of the domain for which to delete the DKIM key.

    .EXAMPLE
        Remove-MHDkimKey -Domain "example.com"

        Deletes the DKIM key for the domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DkimKey.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to delete the DKIM key.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/dkim"
    }

    process {
        foreach ($DomainItem in $Domain) {
            # Prepare the request body.
            $Body = $Domain

            if ($PSCmdlet.ShouldProcess("DKIM key for domain [$DomainItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting DKIM key for domain [$DomainItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }
            # Return the result.
            $Result
        }
    }
}

function Remove-Domain {
    <#
    .SYNOPSIS
        Deletes one or more domains from mailcow server.

    .DESCRIPTION
        Deletes one or more domains from mailcow server.

    .PARAMETER Identity
        The domain name to delete.

    .EXAMPLE
        Remove-MHDomain -Identity "example.com"

        Deletes domain "example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to delete.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $Identity

            if ($PSCmdlet.ShouldProcess("domain [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain [$IdentityItem]." -Level Warning
                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-DomainAdmin {
    <#
    .SYNOPSIS
        Deletes one or more domain admin user accounts.

    .DESCRIPTION
        Deletes one or more domain admin user accounts.

    .PARAMETER Identity
        The username of the domain admin user account to be deleted.

    .EXAMPLE
        Remove-MHDomainAdmin -Identity "ExampDaAdmin"

        Deletes the user account "ExampleDaAdmin".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin user account to be deleted.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("Username")]
        [System.String[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain-admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem

            if ($PSCmdlet.ShouldProcess("domain admin [$IdentityItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain admin [$IdentityItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }
            # Return the result.
            $Result
        }
    }
}

function Remove-DomainAntiSpamPolicy {
    <#
    .SYNOPSIS
        Remove one ore more blacklist or whitelist policies.

    .DESCRIPTION
        Remove one ore more blacklist or whitelist policies.

    .PARAMETER Id
        The id of the policy to remove.

    .EXAMPLE
        Remove-MHDomainAntiSpamPolicy -Id 17

        Removes policy with id 17.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainAntiSpamPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The id of the policy to remove.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain-policy/"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("AntiSpam policy [$($Id -join ", ")]", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting AntiSpam policy [$($Id -join ", ")]." -Level Warning
            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $UriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}

function Remove-DomainTag {
    <#
    .SYNOPSIS
        Remove one or more tags from one or more domains.

    .DESCRIPTION
        Remove one or more tags from one or more domains.

    .PARAMETER Identity
        The domain name from where to remove a tag.

    .PARAMETER Tag
        The tag to remove.

    .EXAMPLE
        Remove-MHDomainTag -Identity "example.com" -Tag "MyTag"

        Removes the tag "MyTag" from domain "example.com".

    .EXAMPLE
        Get-MHDomain -Tag "MyTag" | Remove-MHDomainTag -Tag "MyTag"

        Gets all domains tagged with "MyTag" and removes that tag.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainTag.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name from where to remove a tag.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The tag to remove.")]
        [System.String[]]
        $Tag
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/tag/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + "$($IdentityItem.ToLower())"

            # Prepare the request body.
            $Body = $Tag

            if ($PSCmdlet.ShouldProcess("domain tag [$($Tag -join ',')]", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain tag [$($Tag -join ',')] from domain [$DomainItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-DomainTemplate {
    <#
    .SYNOPSIS
        Remove one or more domain templates.

    .DESCRIPTION
        Remove one or more domain templates.

    .PARAMETER Id
        The id of the domain template to delete.

    .EXAMPLE
        Remove-MHDomainTemplate -Id 17

        Deletes domain template with id 17.

    .EXAMPLE
        (Get-MHDomainTemplate | Where-Object {$_.Name -eq "test"}).Id | Remove-MHDomainTemplate

        Get the domain template with name "test" and delete it.

    .INPUTS
        System.Int64[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the domain template to delete.")]
        [System.Int64[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/domain/template/"
    }

    process {
        # Make an API call for each ID.
        # The API shouuld be able to handle multiple IDs in "$Body.ids" as an array. But this seems not to work correctly.
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                ids = $IdItem.ToSTring()
            }

            if ($PSCmdlet.ShouldProcess("domain template [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting domain template [$IdItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-ForwardingHost {
    <#
    .SYNOPSIS
        Delete one or more forwarding host from the mailcow configuration.

    .DESCRIPTION
        Delete one or more forwarding host from the mailcow configuration.

    .PARAMETER Hostname
        The hostname of the forwarding host to delete.

    .PARAMETER IpAddress
        IP address of a forwarding host to delete.

    .EXAMPLE
        Remove-MHForwardingHost -Hostname mail.example.com

        This will delete all entries found for the forwarding host mail.example.com.

    .EXAMPLE
        Remove-MHForwardingHost IpAddress 1.2.3.4

        This will delete the forwarding host with ip address 1.2.3.4.

    .INPUTS
        System.String[]
        System.Net.IPNetwork[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "Hostname", SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "Hostname", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The Hostname of the forwarding host to delete.")]
        [System.String[]]
        $Hostname,

        [Parameter(ParameterSetName = "IpAddress", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "IP address of a forwarding host to delete.")]
        [System.Net.IPNetwork[]]
        $IpAddress
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/fwdhost"
    }

    process {
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            # Get the ip addresses associated with the specified hostname(s).
            $ForwardingHosts = Get-ForwardingHost | Where-Object { $Hostname -contains $_.source }
            $IpOrHostname = $ForwardingHosts.host
        }
        elseif ($PSBoundParameters.ContainsKey("IpAddress")) {
            # Get the IP address(es) as string value.
            $IpOrHostname = foreach ($Item in $IpAddress) { $Item.ToString() }
        }
        else {
            # Should never reach this point.
            Write-MailcowHelperLog -Message "Invalid option!" -Level Error
        }

        # Prepare the request body.
        $Body = $IpOrHostname

        if ($PSCmdlet.ShouldProcess("forwarding host [$($IpOrHostname -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting forwarding host [$($IpOrHostname -join ",")]." -Level Warning

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Remove-Mailbox {
    <#
    .SYNOPSIS
        Delete one or more mailboxes.

    .DESCRIPTION
        Delete one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox to be deleted.

    .EXAMPLE
        Remove-MHMailbox -Identity "user123@example.com"

        Deletes the mailbox with address "user123@example.com".

    .EXAMPLE
        Remove-MHMailbox -Identity "user123@example.com", "user456@example.com" -Confirm:$false

        Deletes the mailboxes with address "user123@example.com" and "user456@example.com" without extra confirmation.

    .EXAMPLE
        (Get-MHMailbox -Tag "MarkedForDeletion").Username | Remove-MHMailbox -Confirm:$false

        Returns all mailboxes with the tag "MarkedForDeletion" and pipes it to the Remove-MHMailbox function to delete it without further confirmation.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to be deleted.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/mailbox"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("mailbox [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailbox [$($IdentityItem.Address)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-MailboxTag {
    <#
    .SYNOPSIS
        Remove one or more tags from one or more mailboxes.

    .DESCRIPTION
        Remove one or more tags from one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox from where to remove a tag.

    .PARAMETER Tag
        The tag to remove.

    .EXAMPLE
        Remove-MHMailboxTag -Identity "user123@example.com" -Tag "MyTag"

        Removes the tag "MyTag" from mailbox "user123@example.com".

    .EXAMPLE
        Get-MHMailbox -Tag "MyTag" | Remove-MHMailboxTag -Tag "MyTag"

        Gets all mailboxes tagged with "MyTag" and removes that tag.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTag.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox from where to remove a tag.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The tag to remove.")]
        [System.String[]]
        $Tag
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/mailbox/tag/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode("$($IdentityItem.Address.ToLower())")

            # Prepare the request body.
            $Body = $Tag

            if ($PSCmdlet.ShouldProcess("mailbox tag [$($Tag -join ',')].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailbox tag [$($Tag -join ',')] from mailbox [$($IdentityItem.Address)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-MailboxTemplate {
    <#
    .SYNOPSIS
        Remove one or more mailbox templates.

    .DESCRIPTION
        Remove one or more mailbox templates.

    .PARAMETER Id
        The id of the mailbox template to delete.

    .EXAMPLE
        Remove-MHMailboxTemplate -Id 17

        Deletes mailbox template with id 17.

    .EXAMPLE
        (Get-MHMailboxTemplate | Where-Object {$_.Name -eq "test"}).Id | Remove-MHMailboxTemplate

        Get the mailbox template with name "test" and delete it.

    .INPUTS
        System.Int64[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the mailbox template to delete.")]
        [System.Int64[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/mailbox/template/"
    }

    process {
        # Make an API call for each ID.
        # The API shouuld be able to handle multiple IDs in "$Body.ids" as an array. But this seems not to work correctly.
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                ids = $IdItem.ToSTring()
            }

            if ($PSCmdlet.ShouldProcess("mailbox template $($IdItem)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailbox template [$($IdItem)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-OauthClient {
    <#
    .SYNOPSIS
        Remove one or more OAuth client configurations.

    .DESCRIPTION
        Remove one or more OAuth client configurations.

    .PARAMETER Id
        The id value of a specific OAuth client.

    .EXAMPLE
        Remove-MHOauthClient -Id 12

        Removes OAuth client configuration with id 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/oauth2-client"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            if ($PSCmdlet.ShouldProcess("Oauth client [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting Oauth client [$IdItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-QuarantineItem {
    <#
    .SYNOPSIS
        Remove one or more mail items from the quarantine.

    .DESCRIPTION
        Remove one or more mail items from the quarantine.

    .PARAMETER Id
        The id of the item in the quarantine to be deleted.

    .EXAMPLE
        Remove-MHQuarantineItem -Id 17

        Removes the mail item with id 17.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-QuarantineItem.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The id of the item in the quarantine to be deleted.")]
        [System.Int32[]]
        $Id
    )

    # Prepare the base Uri path.
    $UriPath = "delete/qitem"

    # Prepare the request body.
    $Body = foreach ($IdItem in $Id) { $IdItem.ToString() }

    if ($PSCmdlet.ShouldProcess("mail quarantine [$($Id -join ",")].", "Delete")) {
        Write-MailcowHelperLog -Message "Deleting item from quarantine [$($Id -join ",")]." -Level Warning

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
    }

    # Return the result.
    $Result
}

function Remove-Queue {
    <#
    .SYNOPSIS
        Delete the current mail queue. This will delete all mails in the queue.

    .DESCRIPTION
        Delete the current mail queue. This will delete all mails in the queue.

    .EXAMPLE
        Remove-MHQueue

        Delete the current mail queue. This will delete all mails in the queue.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Queue.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param()

    # Prepare the base Uri path.
    $UriPath = "delete/mailq"

    # Prepare the request body.
    $Body = @{
        action = "super_delete"
    }

    if ($PSCmdlet.ShouldProcess("mail queue.", "Delete")) {
        Write-MailcowHelperLog -Message "Deleting all mails in the queue." -Level Warning
        # Execute the API call.
        $Result = Invoke-MailcowApiRequest -UriPath $UriPath -Method Post -Body $Body

        # Return the result.
        $Result
    }
}

function Remove-RateLimit {
    <#
    .SYNOPSIS
        Remove the rate limit for one or more mailboxs or domains.

    .DESCRIPTION
        Remove the rate limit for one or more mailboxs or domains.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to remove the rate-limit setting.

    .PARAMETER Domain
        The name of the domain for which to remove the rate-limit setting.

    .EXAMPLE
        Remove-MHRateLimit -Mailbox "user123@example.com"

        Removes the rate limit for mailbox of user "user123@example.com".

    .EXAMPLE
        Remove-MHRateLimit -Domain "example.com"

        Removes the rate limit for domain "example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RateLimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to remove the rate-limit setting.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to remove the rate-limit setting.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain
    )

    begin {
        # Prepare the base Uri path.
        switch ($PSCmdlet.ParameterSetName) {
            "Mailbox" {
                $UriPath = "edit/rl-mbox"
                $MailboxOrDomain = foreach ($MailboxItem in $Mailbox) { $MailboxItem.Address }
            }
            "Domain" {
                $UriPath = "edit/rl-domain"
                $MailboxOrDomain = $Domain
            }
            default {
                # Should not reach this point.
                throw "Invalid parameter set detected. Can not continue."
            }
        }
    }

    process {
        foreach ($MailboxOrDomainItem in $MailboxOrDomain) {
            # Prepare the request body.
            $Body = @{
                items = $MailboxOrDomainItem
                attr  = @{
                    rl_value = "0"
                    # It does not really matter what time frame is specified, because rl_value = 0 disables it anyway, but the option is required in the API call.
                    rl_frame = "h"
                }
            }

            if ($PSCmdlet.ShouldProcess("rate limit for mailbox or domain [$MailboxOrDomain]", "Delete")) {
                Write-MailcowHelperLog -Message "Delete rate limit for mailbox or domain [$MailboxOrDomain]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-MHResource {
    <#
    .SYNOPSIS
        Remove one or more resource accounts.

    .DESCRIPTION
        Remove one or more resource accounts.

    .PARAMETER Identity
        The mail address of the resource to be deleted.

    .EXAMPLE
        Remove-MHResource -Identity "resource123@example.com"

        Removes the resource with mail address "resource123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the resource to be deleted.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/resource"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = $IdentityItem.Address

            if ($PSCmdlet.ShouldProcess("resource [$($IdentityItem.Address)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting resource [$($IdentityItem.Address)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-RoutingRelayHost {
    <#
    .SYNOPSIS
        Removes one or more relay hosts configured on a mailcow server.

    .DESCRIPTION
        Removes one or more relay hosts configured on a mailcow server.

    .PARAMETER Id
        The id of a relay host entry to update.

    .EXAMPLE
        Remove-MHRoutingRelayHost -id 12

        Remove relay host entry with id 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/relayhost"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            # Get current configuration for specified ID.
            $CurrentRelayHostConfig = Get-RoutingRelayHost -Id $IdItem

            if ($PSCmdlet.ShouldProcess("mailcow relay host [$($CurrentRelayHostConfig.hostname)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting relay host [$($CurrentRelayHostConfig.hostname)], ID [$($CurrentRelayHostConfig.id)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-RoutingTransport {
    <#
    .SYNOPSIS
        Removes one or more transport map configurations.

    .DESCRIPTION
        Removes one or more transport map configurations.

    .PARAMETER Id
        The ID number of a specific transport map record.

    .EXAMPLE
        Remove-MHRoutingTransport -Id 7

        Removes transport rule with id 7.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/transport"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = $IdItem

            # Get current configuration for specified ID.
            $CurrentTransportConfig = Get-RoutingTransport -Identity $IdItem

            if ($PSCmdlet.ShouldProcess("mail transport [$($CurrentTransportConfig.hostname)].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting mailcow mail transport [$($CurrentTransportConfig.hostname)], ID [$($CurrentTransportConfig.id)]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-RspamdSetting {
    <#
    .SYNOPSIS
        Removes one or more Rspamd rules.

    .DESCRIPTION
        Removes one or more Rspamd rules.

    .PARAMETER Id
        The ID number of a specific Rspamd rule.

    .EXAMPLE
        Remove-MHRspamdSetting -Id 1

        Returns rule with id 1.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific Rspamd rule.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/rsetting"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("Rspamd rule [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting Rspamd rule [$($Id -join ",")]." -Level Warning

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
        }
        # Return the result.
        $Result
    }
}

function Remove-SieveFilter {
    <#
    .SYNOPSIS
        Removes one or more admin defined Sieve filter scripts.

    .DESCRIPTION
        Removes one or more admin defined Sieve filter scripts.

    .PARAMETER Id
        The id of the filter script.

    .EXAMPLE
        Remove-MHSieveFilter -Id 14

        Removes filter script with id 14.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the filter script.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/filter/"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("Sieve filter script [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting Sieve filter script [$($Id -join ",")]." -Level Warning

            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $UriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}

function Remove-SyncJob {
    <#
    .SYNOPSIS
        Remove one or more sync jobs from the mailcow server.

    .DESCRIPTION
        Remove one or more sync jobs from the mailcow server.

    .PARAMETER Id
        The ID number for the sync job to delete.

    .EXAMPLE
        Remove-MHSyncJob -Id 8

        Removes sync job with ID number 8.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number for the sync job to delete.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/syncjob"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = $IdItem

            if ($PSCmdlet.ShouldProcess("syncjob [$IdItem].", "Delete")) {
                Write-MailcowHelperLog -Message "Deleting syncjob [$IdItem]." -Level Warning

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Remove-TlsPolicyMap {
    <#
    .SYNOPSIS
        Removes one or more TLS policy map override maps.

    .DESCRIPTION
        Removes one or more TLS policy map override maps.

     .PARAMETER Id
        The TLS policy map ID to delete.

    .EXAMPLE
        Remove-MHTlsPolicyMap -Id 12

        Delete TLS policy map with id 12.

    .EXAMPLE
        Get-MHTlsPolicyMap -Identity 17 | Remove-MHTlsPolicyMap

        Delete TLS policy map with id 12.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Remove-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The TLS policy map ID to delete.")]
        [System.Int32[]]
        $Id
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "delete/tls-policy-map"
    }

    process {
        # Prepare the request body.
        $Body = $Id

        if ($PSCmdlet.ShouldProcess("TLS policy map [$($Id -join ",")].", "Delete")) {
            Write-MailcowHelperLog -Message "Deleting TLS policy map [$($Id -join ",")]." -Level Warning

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-AddressRewriteBccMap {
    <#
    .SYNOPSIS
        Updates one or more BCC maps.

    .DESCRIPTION
        Updates one or more BCC maps.
        BCC maps are used to silently forward copies of all messages to another address.
        A recipient map type entry is used, when the local destination acts as recipient of a mail. Sender maps conform to the same principle.
        The local destination will not be informed about a failed delivery.

    .PARAMETER Id
        The mail address or the The name of the domain for which to edit a BCC map.

    .PARAMETER BccDestination
        The Bcc target mail address.

    .PARAMETER Enable
        By default new BCC maps are always enabled.
        To create a new BCC map in disabled state, specify "-Enable:$false".

    .EXAMPLE
        Set-MHAddressRewriteBccMap -Id 15 -BccDestination "user2@example.com"

        Sets the BCC destiontion to "user2@example.com" for the BCC map with ID 15.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteBccMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Id number of BCC map to edit.")]
        [Alias("BccMapId")]
        [System.Int32[]]
        $Id,

        [Parameter(Mandatory = $false)]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Target")]
        [System.Net.Mail.MailAddress]
        $BccDestination,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/bcc"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("BccDestination")) {
            $Body.attr.bcc_dest = $BccDestination.Address
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("BCC map [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating BCC map [$($Id -join ",")] with target address [$($BccDestination.Address)]." -Level Information
            # Execute the API call.
            $Result = Invoke-MailcowApiRequest -UriPath $UriPath -Method Post -Body $Body

            # Return the result.
            $Result
        }
    }
}

function Set-AddressRewriteRecipientMap {
    <#
    .SYNOPSIS
        Updates one or more address rewriting recipient maps.

    .DESCRIPTION
        Updates one or more address rewriting recipient maps.
        Recipient maps are used to replace the destination address on a message before it is delivered.

    .PARAMETER Id
        The address rewrite recipient map id.

    .PARAMETER OriginalDomainOrMailAddress
        The domain or mail address for which to redirect mails.

    .PARAMETER TargetDomainOrMailAddress
        The target domain or mail address.

    .PARAMETER Enable
        Enable or disable the recipient map.

    .EXAMPLE
        Set-MHAddressRewriteRecipientMap -Id 4 -TargetDomainOrMailAddress example.com

        Updates the address rewrite to the new target domain "example.com" for recipient map with id 4.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AddressRewriteRecipientMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The address rewrite recipient map id.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The domain or mail address for which to redirect mails.")]
        [MailcowHelperArgumentCompleter(("Domain", "Mailbox"))]
        [System.String]
        $OriginalDomainOrMailAddress,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The target domain or mail address.")]
        [MailcowHelperArgumentCompleter(("Domain", "Mailbox"))]
        [System.String]
        $TargetDomainOrMailAddress,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the recipient map.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/recipient_map"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                items = $IdItem
                attr  = @{}
            }

            if ($PSBoundParameters.ContainsKey("OriginalDomainOrMailAddress")) {
                $Body.attr.recipient_map_old = $OriginalDomainOrMailAddress.Trim()
            }
            if ($PSBoundParameters.ContainsKey("TargetDomainOrMailAddress")) {
                $Body.attr.recipient_map_new = $TargetDomainOrMailAddress.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("recipient map [$IdItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating recipient map [$IdItem] with target domain or mail address [$($TargetDomainOrMailAddress.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-Admin {
    <#
    .SYNOPSIS
        Updates an admin user account.

    .DESCRIPTION
        Updates an admin user account.

    .PARAMETER Username
        The login name for the new admin user account.

    .PARAMETER Password
        The password for the new admin user account as secure string.

    .PARAMETER Enable
        Enable or disable the new admin user account. By default all new admin accounts are created in enabled state.
        Use "-Enable:$false" to create an account in disabled state.

    .EXAMPLE
        Set-MHAdmin -Username "cowboy"

        This will create a new admin user account named "cowboy". The password is mandatory and requested to be typed in as secure string.

    .INPUTS
        System.String

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Admin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "Username of the admin user account to update.")]
        [Alias("Identity")]
        [System.String]
        $Username,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The new password for the admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/admin"
    }

    process {
        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = $Identity
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
            $Body.attr.password2 = $Password | ConvertFrom-SecureString -AsPlainText
        }

        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailcow admin user account [$Identity].", "Update")) {
            Write-MailcowHelperLog -Message "Updating admin user account [$Identity]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-AliasDomain {
    <#
    .SYNOPSIS
        Updates one or more alias domains.

    .DESCRIPTION
        Updates one or more alias domains.

    .PARAMETER Identity
        The alias domain name.

    .PARAMETER TargetDomain
        The target domain for the  alias.

    .PARAMETER Enable
        Enable or disable the alias domain.

    .EXAMPLE
        Set-MHAliasDomain -Identity "alias.example.com" -TargetDomain "example.com"

        Sets the target domain to "example.com" for the existing alis domain "alias.example.com".

    .EXAMPLE
        Set-MHAliasDomain -Identity "alias.example.com" -Enable:$false

        Disables the alias domain "alias.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasDomain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias domain name.")]
        [MailcowHelperArgumentCompleter("AliasDomain")]
        [Alias("AliasDomain", "Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The target domain for the alias domain.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $TargetDomain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the alias domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/alias-domain"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.Trim().ToLower()
                attr  = @{
                    # Set the Alias domain name.
                    alias_domain  = $IdentityItem.Trim().ToLower()
                    # Set the target domain name for the alias domain.
                    target_domain = $TargetDomain.Trim().ToLower()
                }
            }
            if ($PSBoundParameters.ContainsKey("TargetDomain")) {
                # Set the rate limit unit, if it was specified.
                $Body.attr.target_domain = $TargetDomain.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                # Set the active state in case the "Enable" parameter was specified based on it's value.
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("alias domain [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating alias domain [$IdentityItem]." -Level Information
                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-AliasMail {
    <#
    .SYNOPSIS
        Update a mail alias.

    .DESCRIPTION
        Update a mail alias.

    .PARAMETER Identity
        The alias mail address to update.

    .PARAMETER Destination
        The destination mail address for the alias.

    .PARAMETER SilentlyDiscard
        If specified, silently discard mail messages sent to the alias address.

    .PARAMETER LearnAsSpam
        If specified, all mails sent to the alias are treated as spam (blacklisted).

    .PARAMETER LearnAsHam
        If specified, all mails sent to the alias are treated as "ham" (whitelisted).

    .PARAMETER Enable
        Enalbe or disable the alias address.

    .PARAMETER Internal
        Internal aliases are only accessible from the own domain or alias domains.

    .PARAMETER SOGoVisible
        Make the new alias visible ein SOGo.

    .PARAMETER PublicComment
        Specify a public comment.

    .PARAMETER PrivateComment
        Specify a private comment.

    .PARAMETER AllowSendAs
        Allow the destination mailbox uesrs to SendAs the alias.

    .EXAMPLE
        Set-MHAliasMail -Alias "alias@example.com" -Destination "mailbox@example.com" -SOGoVisible

        Creates an alias "alias@example.com" for mailbox "mailbox@example.com". The alias will be visible for the user in SOGo.

    .EXAMPLE
        Set-MHAliasMail -Alias "spam@example.com" -Destination "mailbox@example.com" LearnAsSpam

        Creates an alias "spam@example.com" for mailbox "mailbox@example.com". Mails sent to the new alias will be treated as spam.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasMail.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, DefaultParameterSetName = "DestinationMailbox")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The alias mail address to update.")]
        [MailcowHelperArgumentCompleter("Alias")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress]
        $Identity,

        [Parameter(ParameterSetName = "DestinationMailbox", Position = 1, Mandatory = $false, HelpMessage = "The destination mail address for the alias.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Destination,

        [Parameter(ParameterSetName = "DestinationDiscard", Position = 2, Mandatory = $false, HelpMessage = "Silently discard mail messages sent to the alias address.")]
        [System.Management.Automation.SwitchParameter]
        $SilentlyDiscard,

        [Parameter(ParameterSetName = "DestinationSpam", Position = 3, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as spam (blacklisted)")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsSpam,

        [Parameter(ParameterSetName = "DestinationHam", Position = 4, Mandatory = $false, HelpMessage = "All mails sent to the alias are treated as 'ham' (whitelisted).")]
        [System.Management.Automation.SwitchParameter]
        $LearnAsHam,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Allows to enable or disable the new alias.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Internal aliases are only accessible from the own domain or alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $Internal,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Make the new alias visiabl ein SOGo.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoVisible,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify a public comment.")]
        [System.String]
        $PublicComment,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify a private comment.")]
        [System.String]
        $PrivateComment,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Allow the destination mailbox uesrs to SendAs the alias.")]
        [System.Management.Automation.SwitchParameter]
        $AllowSendAs
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/alias"
    }

    process {
        # First get the ID value of the specified alias email address.
        $AliasId = Get-AliasMail -Identity $Identity.Address

        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            # Set the alias ID that should be updated.
            items = $AliasId.Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Destination")) {
            # Set the specified destination address.
            $Destinations = foreach ($DestinationItem in $Destination) { $DestinationItem.Address }
            $Body.attr.goto = [System.String]$Destinations -join ","
        }
        if ($PSBoundParameters.ContainsKey("SilentlyDiscard")) {
            # Set the destination to "null@localhost".
            $Body.attr.goto_null = "1"
        }
        if ($PSBoundParameters.ContainsKey("LearnAsSpam")) {
            # Set the destination to "spam@localhost".
            $Body.attr.goto_spam = "1"
        }
        if ($PSBoundParameters.ContainsKey("LearnAsHam")) {
            # Set the destination to "ham@localhost".
            $Body.attr.goto_ham = "1"
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            # Set the active state in case the "Enable" parameter was specified based on it's value.
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Internal")) {
            # Set if the alias should be reachable only internal.
            $Body.attr.internal = if ($Internal.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SOGoVisible")) {
            # Set if the alias should be availabl ein SOGo.
            $Body.attr.sogo_visible = if ($SOGoVisible.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PublicComment")) {
            # Set the public comment for the alias.
            $Body.attr.public_comment = $PublicComment
        }
        if ($PSBoundParameters.ContainsKey("PrivateComment")) {
            # Set the private comment for the alias.
            $Body.attr.private_comment = $PrivateComment
        }
        if ($PSBoundParameters.ContainsKey("AllowSendAs")) {
            # Set SenderAllowed option.
            $Body.attr.sender_allowed = if ($AllowSendAs.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("alias [$($Identity.Address)].", "Update")) {
            Write-MailcowHelperLog -Message "Updating alias id [$($AliasId.Id)] with address [$($Identity.Address)]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-AliasTimeLimited {
    <#
    .SYNOPSIS
        Updates one or more time-limited aliases (spamalias).

    .DESCRIPTION
        Updates one or more time-limited aliases (spamalias).

    .PARAMETER Identity
        The time-limited alias mail address to be updated.

    .PARAMETER Permanent
        If specified, the time-limit alias will be set to never expire.

    .PARAMETER ExpireIn
        Set a predefined time period. Allowed values are:
        1Hour, 1Day, 1Week, 1Month, 1Year, 10Years

    .PARAMETER ExpireInHours
        Set a custom value as number of hours from now.
        The valid range is 1 to 105200, which is between 1 hour and about 12 years.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -Permanent

        Set the alias "alias@example.com" to not expire.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireIn "1Week"

        Set the alias "alias@example.com" to expire in 1 week from now.

    .EXAMPLE
        Set-MHAliasTimeLimited -Identity "alias@example.com" -ExpireInHours 48

        Set the alias "alias@example.com" to expire in 48 hours from now.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AliasTimeLimited.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "ExpireIn", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The time-limited alias mail address to be updated.")]
        [Alias("Alias")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "Permanent", Position = 1, Mandatory = $true, HelpMessage = "If specified, the time-limited alias will not expire.")]
        [System.Management.Automation.SwitchParameter]
        $Permanent,

        [Parameter(ParameterSetName = "ExpireIn", Position = 1, Mandatory = $true, HelpMessage = "Set when the time-limited alias should expire by selecting from a list of timeframes.")]
        [ValidateSet("1Hour", "1Day", "1Week", "1Month", "1Year", "10Years")]
        [System.String]
        $ExpireIn,

        [Parameter(ParameterSetName = "ExpireInHours", Position = 1, Mandatory = $true, HelpMessage = "Specify in how many hours the time-limited alias should exipre.")]
        [ValidateRange(1, 105200)]
        [System.Int32]
        $ExpireInHours
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/time_limited_alias"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.Address
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Permanent")) {
                $Body.attr.permanent = if ($Permanent.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("ExpireIn")) {
                # Calculate the ExpireInHours value based on the selected input.
                switch ($ExpireIn) {
                    "1Hour" {
                        $ExpireInHours = 1
                        break
                    }
                    "1Day" {
                        $ExpireInHours = 1 * 24
                        break
                    }
                    "1Week" {
                        $ExpireInHours = 1 * 24 * 7
                        break
                    }
                    "1Month" {
                        # Either simply calculate 1 month of 30 days.
                        # $ExpireInHours = 1 * 24 * 30
                        # Or use the Get-Date function and add 1 month, which considers the real number of days of a month.
                        $ExpireInHours = ((Get-Date).AddYears(10) - (Get-Date)).TotalHours
                        break
                    }
                    "1Year" {
                        # Either simply calculate 1 years of 365 days (ignoring leap years).
                        # $ExpireInHours = 1 * 24 * 365
                        # Or use the Get-Date function and add 1 year, which respects leap years.
                        $ExpireInHours = ((Get-Date).AddYears(1) - (Get-Date)).TotalHours
                        break
                    }
                    "10Years" {
                        # Either simply calculate 10 years of 365 days (ignoring leap years).
                        # $ExpireInHours = 1 * 24 * 365 * 10
                        # Or use the Get-Date function and add 10 years, which respects leap years.
                        $ExpireInHours = ((Get-Date).AddYears(10) - (Get-Date)).TotalHours
                        break
                    }
                    default {
                        # Should never reach this point.
                        break
                    }
                }
                $Body.attr.validity = $ExpireInHours
            }
            if ($PSBoundParameters.ContainsKey("ExpireInHours")) {
                # Set the number of hours as specified.
                $Body.attr.validity = $ExpireInHours
            }

            if ($PSCmdlet.ShouldProcess("time-limited alias [$($IdentityItem.Address)].", "Update")) {
                Write-MailcowHelperLog -Message "Updating time-limited alias [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-AppPassword {
    <#
    .SYNOPSIS
        Updates one or more users application-specific password configurations.

    .DESCRIPTION
        Updates one or more users application-specific password configurations.

        To update an app password configuration, the app password id and the mailbox address
        must be specified.

    .PARAMETER Id
        The app password id.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to update the app password.

    .PARAMETER Name
        A name for the app password.

    .PARAMETER Password
        The password to set.

    .PARAMETER Protocol
        The protocol(s) for which the app password can be used.
        One or more of the following values:
        IMAP, DAV, SMTP, EAS, POP3, Sieve

    .PARAMETER Enable
        Enable or disable the app password.

    .EXAMPLE
        Set-MHAppPassword -Identity 7 -Name "New name for app password" -Protcol "EAS"

        Change the name for app password with ID 7 to "New name for app passwrord" and change the protocol to allow only "EAS".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-AppPassword.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The app password id.")]
        [Alias("AppPasswordId")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The mail address of the mailbox for which to update the app password.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress]
        $Mailbox,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "A name for the app password.")]
        [Alias("AppName")]
        [System.String]
        $Name,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The password to set.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The protocol(s) for which the app password can be used.")]
        [ValidateSet("IMAP", "DAV", "SMTP", "EAS", "POP3", "Sieve")]
        [System.String[]]
        $Protocol,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the app password.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/app-passwd"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Identity")) {
            $Body.attr.username = $Identity.Address
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.app_passwd = $Password | ConvertFrom-SecureString -AsPlainText
            $Body.attr.app_passwd2 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Name")) {
            $Body.attr.app_name = $Name
        }
        if ($PSBoundParameters.ContainsKey("Protocol")) {
            $Body.attr.protocols = foreach ($ProtocolItem in $Protocol) { $($ProtocolItem.ToLower()) + "_access" }
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("app password id [$($Id -join ",")].", "update")) {
            Write-MailcowHelperLog -Message "Updating app password id [$($Id -join ",")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-Domain {
    <#
    .SYNOPSIS
        Update one or more domains on the mailcow server.

    .DESCRIPTION
        Update one or more domains on the mailcow server.

    .PARAMETER Domain
        The domain name to update.

    .PARAMETER Description
        A description for the domain.

    .PARAMETER Enable
        Enable or disable the domain.

    .PARAMETER MaxMailboxCount
        Specify the maximum number of mailboxes allowed for the domain.
        Defaults to 10.

    .PARAMETER MaxAliasCount
        Specify the maximum number of aliases allowed for the domain.
        Defaults to 400.

    .PARAMETER DefaultMailboxQuota
        Specify the default mailbox quota.
        Defaults to 3072.

    .PARAMETER MailboxQuota
        Specify the maximum mailbox quota.
        Defaults to 10240.

    .PARAMETER TotalDomainQuota
        Specify the total domain quota valid for all mailboxes in the domain.
        Defaults to 10240.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain created.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain.

    .PARAMETER Tag
        Add a tag to the new domain.

    .PARAMETER RateLimit
        Set the message rate limit for the domain.
        Defaults to 10.

    .PARAMETER RateLimitPerUnit
        Set the message rate limit unit.
        Defaults to seconds.

    .EXAMPLE
        Set-MHDomain -Domain "example.com" -MaxMailboxCount 100

        Sets the mailbox count value for the domain "example.com" to 100.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Domain.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The domain name to add.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "A description for the new domain.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable the domain.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Specify the maximum number of mailboxes allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxCount = 10,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Specify the maximum number of aliases allowed for the domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxAliasCount = 400,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Specify the default mailbox quota.")]
        # Default mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $DefaultMailboxQuotaMB = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specify the maximum mailbox quota.")]
        # Max. mailbox quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $MaxMailboxQuotaMB = 10240,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify the total domain quota valid for all mailboxes in the domain.")]
        # Total domain quota accepts max 8 Exabyte.
        [ValidateRange(1, 9223372036854775807)]
        [System.Int64]
        $TotalDomainQuotaMB = 10240,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly,

        [Parameter(Position = 12, Mandatory = $false)]
        [System.String[]]
        $Tag,

        [Parameter(Position = 13, Mandatory = $false)]
        [ValidateRange(0, 9223372036854775807)]
        [System.Int64]
        $RateLimit = 10,

        [Parameter(Position = 14, Mandatory = $false)]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitPerUnit = "Seconds"
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath

            # Prepare the request body.
            $Body = @{
                items = $IdentityItem
                attr  = @{}
            }

            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("MaxAliasCount")) {
                $Body.attr.aliases = $MaxAliasCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuotaMB")) {
                # Default mailbox quota accepts max 8 Exabyte.
                $Body.attr.defquota = $($DefaultMailboxQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("Description")) {
                if (-not [System.String]::IsNullOrEmpty($Description)) {
                    $Body.attr.description = $Description
                }
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxCount")) {
                $Body.attr.mailboxes = $MaxMailboxCount.ToString()
            }
            if ($PSBoundParameters.ContainsKey("TotalDomainQuotaMB")) {
                # Total mailbox quota accepts max 8 Exabyte.
                $Body.attr.quota = $($TotalDomainQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxQuotaMB")) {
                # Mailbox quota accepts max 8 Exabyte.
                $Body.attr.maxquota = $($MaxMailboxQuotaMB).ToString()
            }
            if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
                $Body.attr.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
                $Body.attr.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
                $Body.attr.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
                $Body.attr.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitPerUnit")) {
                $Body.attr.rl_frame = $RateLimitPerUnit.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("RateLimit")) {
                $Body.attr.rl_value = $RateLimit.ToString()
            }
            if (-not [System.String]::IsNullOrEmpty($Tag)) {
                $Body.attr.tags = $Tag
            }

            if ($PSCmdlet.ShouldProcess("domain [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowHelperRequestParams = @{
                    UriPath = $RequestUriPath
                    Method  = "Post"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-DomainAdmin {
    <#
    .SYNOPSIS
        Updates one or more domain admin user accounts.

    .DESCRIPTION
        Updates one or more domain admin user accounts.

    .PARAMETER Identity
        The username of the domain admin account to update.

    .PARAMETER Domain
        Set the domain for which the domain user account should become an admin.

    .PARAMETER NewUsername
        Set the new username for the domain admin user account.

    .PARAMETER Password
        Set the password for the domain admin user account.

    .PARAMETER Enable
        Enable or disable the domain admin user account.

    .EXAMPLE
        Set-MHDomainAdmin -Identity "AdminForExampleDotCom" -Domain "sub.example.com"

        Make the existing domain admin usre "AdminForExampleDotCom" an admin of the domain "sub.example.com".

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdmin.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin account to update.")]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [Alias("Username")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Set the domain for which the domain user account should become an admin.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Set the new username for the domain admin user account.")]
        [System.String]
        $NewUsername,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Set the password for the domain admin user account.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the domain admin user account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain-admin"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $IdentityItem
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Domain")) {
                $Body.attr.domains = $Domain
            }
            if ($PSBoundParameters.ContainsKey("NewUsername")) {
                $Body.attr.username_new = $NewUsername.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Password")) {
                $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
                $Body.attr.password2 = $Password | ConvertFrom-SecureString -AsPlainText
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("domain admin [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain admin [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams
            }

            # Return the result.
            $Result
        }
    }
}

function Set-DomainAdminAcl {
    <#
    .SYNOPSIS
        Updates one or more domain admin ACL (Access Control List) permissions.

    .DESCRIPTION
        Updates one or more domain admin ACL (Access Control List) permissions.

    .PARAMETER Username
        Specifies one or more domain admin usernames whose ACL settings should be updated.

    .PARAMETER All
        Enables all ACL permissions for the specified domain admin(s).

    .PARAMETER SyncJob
        Allows management of sync job settings.

    .PARAMETER Quarantine
        Allows management of quarantine settings.

    .PARAMETER LoginAs
        Allows login as a mailbox user.

    .PARAMETER SogoAccess
        Allows management of SOGo access.

    .PARAMETER AppPassword
        Allows management of app passwords.

    .PARAMETER BccMap
        Allows management of BCC maps.

    .PARAMETER Pushover
        Allows management of Pushover settings.

    .PARAMETER Filter
        Allows management of filters.

    .PARAMETER RateLimit
        Allows management of rate limits.

    .PARAMETER SpamPolicy
        Allows management of spam policy settings.

    .PARAMETER ExtendedSenderAcl
        Allows extending sender ACLs with external addresses.

    .PARAMETER UnlimitedQuota
        Allows setting unlimited mailbox quota.

    .PARAMETER ProtocolAccess
        Allows changing protocol access settings.

    .PARAMETER SmtpIpAccess
        Allows modifying allowed SMTP hosts.

    .PARAMETER AliasDomains
        Allows adding alias domains.

    .PARAMETER DomainDescription
        Allows modifying the domain description.

    .PARAMETER ChangeRelayhostForDomain
        Allows changing the relay host for a domain.

    .PARAMETER ChangeRelayhostForMailbox
        Allows changing the relay host for a mailbox.

    .EXAMPLE
        Set-MHDomainAdminAcl -Username "admin1" -SyncJob -Quarantine -LoginAs

        Enables SyncJob, Quarantine, and LoginAs ACL permissions for the domain admin "admin1".

    .EXAMPLE
        "admin1","admin2" | Set-MHDomainAdminAcl -All

        Enables all ACL permissions for multiple domain admins piped into the function.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainAdminAcl.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "Individual", Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The username of the domain admin for whom to update the ACL.")]
        [Parameter(ParameterSetName = "All", Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("DomainAdmin")]
        [System.String[]]
        $Identity,

        [Parameter(ParameterSetName = "All", Mandatory = $true, HelpMessage = "Enable or disable all ACL entries.")]
        [System.Management.Automation.SwitchParameter]
        $All,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage sync job settings.")]
        [System.Management.Automation.SwitchParameter]
        $SyncJob,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage quarantine settings.")]
        [System.Management.Automation.SwitchParameter]
        $Quarantine,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage login as mailbox user.")]
        [System.Management.Automation.SwitchParameter]
        $LoginAs,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage SOGo access.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AppPassword,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage BCC maps.")]
        [System.Management.Automation.SwitchParameter]
        $BccMap,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage pushover settings.")]
        [System.Management.Automation.SwitchParameter]
        $Pushover,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage filters.")]
        [System.Management.Automation.SwitchParameter]
        $Filter,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage rate limits.")]
        [System.Management.Automation.SwitchParameter]
        $RateLimit,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to manage spam policy.")]
        [System.Management.Automation.SwitchParameter]
        $SpamPolicy,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to extend sender ACL by external addresses.")]
        [System.Management.Automation.SwitchParameter]
        $ExtendedSenderAcl,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to set unlimited quota for mailboxes.")]
        [System.Management.Automation.SwitchParameter]
        $UnlimitedQuota,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change protocol access.")]
        [System.Management.Automation.SwitchParameter]
        $ProtocolAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change allowed hosts for STMP.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpIpAccess,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to add alias domains.")]
        [System.Management.Automation.SwitchParameter]
        $AliasDomains,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the domain description.")]
        [System.Management.Automation.SwitchParameter]
        $DomainDescription,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the relay host for a domain.")]
        [System.Management.Automation.SwitchParameter]
        $ChangeRelayhostForDomain,

        [Parameter(ParameterSetName = "Individual", Mandatory = $false, HelpMessage = "Allow to change the relay host for a mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $ChangeRelayhostForMailbox
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/da-acl"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the request body.
            $Body = @{
                items = $Identity
                attr  = @{}
            }
            $DAACL = @()
            if ($All.IsPresent -or $SyncJob.IsPresent) { $DAACL += "syncjobs" }
            if ($All.IsPresent -or $Quarantine.IsPresent) { $DAACL += "quarantine" }
            if ($All.IsPresent -or $LoginAs.IsPresent) { $DAACL += "login_as" }
            if ($All.IsPresent -or $SogoAccess.IsPresent) { $DAACL += "sogo_access" }
            if ($All.IsPresent -or $AppPassword.IsPresent) { $DAACL += "app_passwds" }
            if ($All.IsPresent -or $BccMap.IsPresent) { $DAACL += "bcc_maps" }
            if ($All.IsPresent -or $Pushover.IsPresent) { $DAACL += "pushover" }
            if ($All.IsPresent -or $Filter.IsPresent) { $DAACL += "filters" }
            if ($All.IsPresent -or $RateLimit.IsPresent) { $DAACL += "ratelimit" }
            if ($All.IsPresent -or $SpamPolicy.IsPresent) { $DAACL += "spam_policy" }
            if ($All.IsPresent -or $ExtendedSenderAcl.IsPresent) { $DAACL += "extend_sender_acl" }
            if ($All.IsPresent -or $UnlimitedQuota.IsPresent) { $DAACL += "unlimited_quota" }
            if ($All.IsPresent -or $ProtocolAccess.IsPresent) { $DAACL += "protocol_access" }
            if ($All.IsPresent -or $SmtpIpAccess.IsPresent) { $DAACL += "smtp_ip_access" }
            if ($All.IsPresent -or $AliasDomains.IsPresent) { $DAACL += "alias_domains" }
            if ($All.IsPresent -or $DomainDescription.IsPresent) { $DAACL += "domain_desc" }
            if ($All.IsPresent -or $ChangeRelayhostForDomain.IsPresent) { $DAACL += "domain_relayhost" }
            if ($All.IsPresent -or $ChangeRelayhostForMailbox.IsPresent) { $DAACL += "mailbox_relayhost" }
            $Body.attr.da_acl = $DAACL

            Write-MailcowHelperLog -Message "Setting the ACL will overwrite any existing ACL. Know what you do!" -Level "Warning"

            if ($PSCmdlet.ShouldProcess("domain admin ACL [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain admin ACL [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-DomainFooter {
    <#
    .SYNOPSIS
        Update the footer of one or more domains.

    .DESCRIPTION
        Update the footer of one or more domains.

    .PARAMETER Identity
        The name of the domain for which to update the footer.

    .PARAMETER HtmlFooter
        Footer in HTML format.

    .PARAMETER PlainFooter
        Footer in plain text format.

    .PARAMETER ExcludeMailbox
        One or more m address(es) to be excluded from the domain wide footer.

    .PARAMETER SkipFooterForReplies
        Don't add footer on reply messages.

    .EXAMPLE
        Set-MHDomainFooter -Identity "example.com" -HtmlFooter (Get-Content -Path "C:\Temp\example-com-footer.html") -SkipFooterForReplies

        This will read the content of the html file "C:\Temp\example-com-footer.html" and set it as footer for the domain "example.com"
        The footer will not be added on reply messages.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainFooter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to update the footer.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Footer in HTML format.")]
        [System.String]
        $HtmlFooter,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Footer in plain text format.")]
        [System.String]
        $PlainFooter,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Mail addres to be excluded from the domain wide footer.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $ExcludeMailbox,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Don't add footer on reply messages.")]
        [System.Management.Automation.SwitchParameter]
        $SkipFooterForReplies
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/footer/"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            items = $Identity
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("HtmlFooter")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Setting HTML footer."
            $Body.attr.html = $HtmlFooter
        }
        if ($PSBoundParameters.ContainsKey("PlainFooter")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Setting PLAIN footer."
            $Body.attr.plain = $PlainFooter
        }
        if ($PSBoundParameters.ContainsKey("ExcludeMailbox")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Excluding mailbox(es)."
            $Body.attr.mbox_exclude = $ExcludeMailbox.Address
        }
        if ($PSBoundParameters.ContainsKey("SkipFooterForReplies")) {
            Write-MailcowHelperLog -Message "[$($Identity -join ", ")] Skipping footer for reply messages."
            $Body.attr.skip_replies = if ($SkipFooterForReplies.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("domain footer [$($Identity -join ", ")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating domain footer [$($Identity -join ", ")]." -Level Information

            # Execute the API call.
            $InvokeMailcowHelperRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "Post"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowHelperRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-DomainTemplate {
    <#
    .SYNOPSIS
        Updates one or more domain templates.

    .DESCRIPTION
        Updates one or more domain templates.
        A domain template can either be specified as a default template for a new domain.
        Or you can select a template when creating a new mailbox to inherit some properties.

    .PARAMETER Id
        The ID value of the mailbox template to update.

    .PARAMETER MaxNumberOfAliasesForDomain
        The maximum number of aliases allowed in a domain.

    .PARAMETER MaxNumberOfMailboxesForDomain
        The maximum number of mailboxes allowed in a domain.

    .PARAMETER DefaultMailboxQuota
        The default mailbox quota limit in MiB.

    .PARAMETER MaxMailboxQuota
        The maximum mailbox quota limit in MiB.

    .PARAMETER MaxDomainQuota
        The domain wide total maximum mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER DkimSelector
        The string to be used as DKIM selector.

    .PARAMETER DkimKeySize
        The DKIM key keysize.

    .PARAMETER Enable
        Enable or disable the domain created by the template.

    .PARAMETER GlobalAddressList
        Enable or disable the Global Address list for the domain created by the template.

    .PARAMETER RelayThisDomain
        Enable or disable the relaying for the domain created by the template.

    .PARAMETER RelayAllRecipients
        Enable or disable the relaying for all recipients for the domain created by the template.

    .PARAMETER RelayUnknownOnly
        Enable or disable the relaying for unknown recipients for the domain created by the template.

    .EXAMPLE
        Set-MHDomainTemplate -Name "MyDefaultDomainTemplate"

        Creates a domain template with the name "MyDefaultDomainTemplate". All values are set to mailcow defaults.

    .EXAMPLE
        Set-MHDomainTemplate -Name "MyDefaultDomainTemplate" -MaxNumberOfAliasesForDomain 1000 -MaxNumberOfMailboxesForDomain 1000 -MaxDomainQuota 102400

        Creates a domain template with the name "MyDefaultDomainTemplate".
        The maximum number of aliases and mailboxes will be set to 1000. The domain wide total mailbox quota will be set to 100 GByte.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-DomainTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The ID value of the mailbox template to update.")]
        [System.Int64[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The name of the domain template.")]
        [System.String]
        $Name,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The maximum number of aliases allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfAliasesForDomain = 400,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The maximum number of mailboxes allowed in a domain.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxNumberOfMailboxesForDomain = 10,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The default mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $DefaultMailboxQuota = 3072,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxMailboxQuota = 10240,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The domain wide total maximum mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MaxDomainQuota = 10240,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter( Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue = 0,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The string to be used as DKIM selector.")]
        [System.String]
        $DkimSelector = "dkim",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "The DKIM key keysize.")]
        [ValidateSet(1024, 2024, 4096, 8192)]
        [System.Int32]
        $DkimKeySize = 2096,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $Enable,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable the Global Address list for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $GlobalAddressList,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable the relaying for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayThisDomain,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable the relaying for all recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayAllRecipients,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Enable or disable the relaying for unknown recipients for the domain created by the template.")]
        [System.Management.Automation.SwitchParameter]
        $RelayUnknownOnly
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/domain/template"
    }

    process {
        # Make an API call for each ID.
        foreach ($IdItem in $Id) {
            # First get the current mailbox template settings to use as base.
            # This is needed because otherwise any option not explicitly specified, will be set to be disabled by the API.
            $CurrentConfig = Get-DomainTemplate -Raw | Where-Object { $_.id -eq $IdItem }

            # Prepare the request body.
            $Body = @{
                items = $IdItem.ToSTring()
                attr  = @{
                    # Set current template settings as base values for the update.
                    template                   = $CurrentConfig.template
                    tags                       = $CurrentConfig.attributes.tags
                    max_num_aliases_for_domain = $CurrentConfig.attributes.max_num_aliases_for_domain
                    max_num_mboxes_for_domain  = $CurrentConfig.attributes.max_num_mboxes_for_domain
                    def_quota_for_mbox         = $CurrentConfig.attributes.def_quota_for_mbox / 1048576 # to convert bytes into MiB.
                    max_quota_for_mbox         = $CurrentConfig.attributes.max_quota_for_mbox / 1048576 # to convert bytes into MiB.
                    max_quota_for_domain       = $CurrentConfig.attributes.max_quota_for_domain / 1048576 # to convert bytes into MiB.
                    rl_frame                   = $CurrentConfig.attributes.rl_frame
                    rl_value                   = $CurrentConfig.attributes.rl_value
                    active                     = $CurrentConfig.attributes.active
                    gal                        = $CurrentConfig.attributes.gal
                    backupmx                   = $CurrentConfig.attributes.backupmx
                    relay_all_recipients       = $CurrentConfig.attributes.relay_all_recipients
                    relay_unknown_only         = $CurrentConfig.attributes.relay_unknown_only
                    dkim_selector              = $CurrentConfig.attributes.dkim_selector
                    key_size                   = $CurrentConfig.attributes.key_size
                }
            }

            if ($PSBoundParameters.ContainsKey("Name")) {
                $Body.attr.template = $Name.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                $Body.attr.tags = $Tag
            }
            if ($PSBoundParameters.ContainsKey("MaxNumberOfAliasesForDomain")) {
                $Body.attr.max_num_aliases_for_domain = $MaxNumberOfAliasesForDomain.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxNumberOfMailboxesForDomain")) {
                $Body.attr.max_num_mboxes_for_domain = $MaxNumberOfMailboxesForDomain.ToString()
            }
            if ($PSBoundParameters.ContainsKey("DefaultMailboxQuota")) {
                $Body.attr.def_quota_for_mbox = $DefaultMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxMailboxQuota")) {
                $Body.attr.max_quota_for_mbox = $MaxMailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("MaxDomainQuota")) {
                $Body.attr.max_quota_for_domain = $MaxDomainQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitValue")) {
                $Body.attr.rl_value = $RateLimitValue.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitFrame")) {
                $Body.attr.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("DkimSelector")) {
                $Body.attr.dkim_selector = $DkimSelector.Trim()
            }
            if ($PSBoundParameters.ContainsKey("DkimKeySize")) {
                $Body.attr.key_size = $DkimKeySize.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("GlobalAddressList")) {
                $Body.attr.gal = if ($GlobalAddressList.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayThisDomain")) {
                $Body.attr.backupmx = if ($RelayThisDomain.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayAllRecipients")) {
                $Body.attr.relay_all_recipients = if ($RelayAllRecipients.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("RelayUnknownOnly")) {
                $Body.attr.relay_unknown_only = if ($RelayUnknownOnly.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("domain template [$IdItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating domain template [$IdItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-Fail2BanConfig {
    <#
    .SYNOPSIS
        Updates the fail2ban configuration of the mailcow server.

    .DESCRIPTION
        Updates the fail2ban configuration of the mailcow server.

    .PARAMETER BanTime
        Specify for how many seconds to ban a source ip.

    .PARAMETER BanTimeIncrement
        Enable or disable the ban time increment.

    .PARAMETER MaxBanTime
        The maximum ban time in seconds.

    .PARAMETER MaxAttempts
        The maximum number of attempts, before an ip gets banned.

    .PARAMETER RetryWindow
        The number of seconds of within failed attempts need to occur to be counted.

    .PARAMETER NetbanIpv4
        IPv4 subnet size to apply ban on (8-32).

    .PARAMETER NetbanIpv6
        IPv6 subnet size to apply ban on (8-128).

    .PARAMETER BlackListIpAddress
        Specify an ip address or ip network to blacklist.

    .PARAMETER WhiteListIpAddress
        Specify an ip address or ip network to whitelist.

    .PARAMETER WhiteListHostname
        Specify a hostname to whitelist.

    .PARAMETER ListOperation
        Specify an action to execute for the list record.

    .EXAMPLE
        Set-MHFail2BanConfig -BanTime 900 -BanTimeIncrement

        This will set the ban time to 900 seconds and enable the ban time imcrement.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Fail2BanConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "Specify for how many seconds to ban a source ip.")]
        [System.Int32]
        $BanTime,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Enable or disable the ban time increment.")]
        [System.Management.Automation.SwitchParameter]
        $BanTimeIncrement,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The maximum ban time in seconds.")]
        [System.Int32]
        $MaxBanTime,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The maximum number of attempts, before an ip gets banned.")]
        [System.Int32]
        $MaxAttempts,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The number of seconds within failed attempts need to occur to be counted.")]
        [System.Int32]
        $RetryWindow,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "IPv4 subnet size to apply ban on (8-32).")]
        [System.Int32]
        $NetbanIpv4,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "IPv6 subnet size to apply ban on (8-128)")]
        [System.Int32]
        $NetbanIpv6,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specify an ip address or ip network to blacklist.")]
        [System.Net.IPNetwork[]]
        $BlackListIpAddress,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify an ip address or ip network to whitelist.")]
        [System.Net.IPNetwork[]]
        $WhiteListIpAddress,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify an hostname to whitelist.")]
        [System.String[]]
        $WhiteListHostname,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Specify the action to execute for the list record.")]
        [ValidateSet("Append", "Overwrite", "Remove")]
        [System.String]
        $ListOperation = "Append"
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/fail2ban"
    }

    process {
        # First get the current Fail2Ban config.
        $CurrentConfig = Get-Fail2BanConfig

        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare the request body.
        $Body = @{
            attr  = $CurrentConfig
            items = "none"
        }
        if ($PSBoundParameters.ContainsKey("BanTime")) {
            $Body.attr.ban_time = $BanTime.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BanTimeIncrement")) {
            $Body.attr.ban_time_increment = if ($BanTimeIncrement.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MaxBanTime")) {
            $Body.attr.max_ban_time = $MaxBanTime.ToString
        }
        if ($PSBoundParameters.ContainsKey("MaxAttempts")) {
            $Body.attr.max_attempts = $MaxAttempts.ToString()
        }
        if ($PSBoundParameters.ContainsKey("RetryWindow")) {
            $Body.attr.retry_window = $RetryWindow.ToString()
        }
        if ($PSBoundParameters.ContainsKey("NetbanIpv4")) {
            $Body.attr.netban_ipv4 = $NetbanIpv4.ToString()
        }
        if ($PSBoundParameters.ContainsKey("NetbanIpv6")) {
            $Body.attr.netban_ipv6 = $NetbanIpv6.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BlackListIpAddress")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.blacklist = $Body.attr.blacklist + "`r`n" + $BlacklistIpAddressItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.blacklist = ""
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.blacklist = $Body.attr.blacklist + "`r`n" + $BlacklistIpAddressItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($BlacklistIpAddressItem in $BlackListIpAddress) {
                        # Replace an entry with an empty string.
                        $Body.attr.blacklist = $Body.attr.blacklist -replace $BlacklistIpAddressItem.ToString(), ""
                    }
                    break
                }
            }
        }
        if ($PSBoundParameters.ContainsKey("WhiteListIpAddress")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListIpAddressItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.whitelist = ""
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListIpAddressItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($WhiteListIpAddressItem in $WhiteListIpAddress) {
                        # Replace an entry with an empty string.
                        $Body.attr.whitelist = $Body.attr.whitelist -replace $WhiteListIpAddressItem.ToString(), ""
                    }
                    break
                }
            }
        }
        if ($PSBoundParameters.ContainsKey("WhiteListHostname")) {
            switch ($ListOperation) {
                "Append" {
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListHostnameItem.ToString()
                    }
                    break
                }
                "Overwrite" {
                    # Remove all current entries form the list.
                    $Body.attr.whitelist = ""
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Append each new entry to the list.
                        $Body.attr.whitelist = $Body.attr.whitelist + "`r`n" + $WhiteListHostnameItem.ToString()
                    }
                    break
                }
                "Remove" {
                    # Remove all the specified entries from the list.
                    foreach ($WhiteListHostnameItem in $WhiteListHostname) {
                        # Replace an entry with an empty string.
                        $Body.attr.whitelist = $Body.attr.whitelist -replace $WhiteListHostnameItem.ToString(), ""
                    }
                    break
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("mailcow fail2ban config.", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailcow fail2ban config." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-ForwardingHost {
    <#
    .SYNOPSIS
        Updates one or more forwarding host configurations.

    .DESCRIPTION
        Updates one or more forwarding host configurations.

    .PARAMETER Hostname
        The hostname or IP address of the forwarding host.

    .PARAMETER FilterSpam
        Enable or disable spam filter.

    .EXAMPLE
        Set-MHForwardingHost -Hostname 1.2.3.4 -FilterSpam:$false

        This will disable spam filtering for the forwarding host 1.2.3.4.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-ForwardingHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The Hostname or IP address of the forwarding host.")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Enable or disable spam filter.")]
        [System.Management.Automation.SwitchParameter]
        $FilterSpam
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/fwdhost"
    }

    process {
        foreach ($HostnameItem in $Hostname) {
            # Prepare the request body.
            $Body = @{
                items = $HostnameItem
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("FilterSpam")) {
                # The "add" route expectes "fitler_spam". The "edit" route expectes "keep_spam".
                $Body.attr.keep_spam = if ($FilterSpam.IsPresent) { "0" } else { "1" }
            }

            if ($PSCmdlet.ShouldProcess("forwarding host [$HostnameItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating forwarding host [$HostnameItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-IdPGenericOIDC {
    <#
    .SYNOPSIS
        Updates settings for a generic OIDC auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a generic OIDC auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a generic OIDC identity provider as auth source in mailcow.

    .PARAMETER AuthorizeUrl
        The provider's authorization server URL.

    .PARAMETER TokenUrl
        The provider's token server URL.

    .PARAMETER UserinfoUrl
        The provider's user info server URL.

    .PARAMETER ClientId
        The Client ID assigned to mailcow Client in OIDC provider.

    .PARAMETER ClientSecret
        The Client Secret assigned to the mailcow client in OIDC provider.

    .PARAMETER RedirectUrl
        The redirect URL that OIDC provider will use after authentication. This should point to your mailcow UI.

    .PARAMETER RedirectUrlExtra
        Additional redirect URL.

    .PARAMETER ClientScope
        Specifies the OIDC scopes requested during authentication.
        The default scopes are openid profile email mailcow_template

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation is bypassed.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .EXAMPLE
        $ClientSecret = Read-Host -AsSecureString

        Set-MHIdPGenericOIDC -AuthorizeUrl "https://auth.mailcow.tld/application/o/authorize/" -TokenUrl "https://auth.mailcow.tld/application/o/token/" -UserinfoUrl "https://auth.mailcow.tld/application/o/userinfo/" -ClientID "mailcow_client" -ClientSecret $ClientSecret -RedirectUrl "https://mail.mailcow.tld"

        Prompts for the client secret and stores in the variable $ClientSecret as secure string.
        Configures settings for using a generic OIDC as identity provider in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The provider's authorization server URL.")]
        [System.Uri]
        $AuthorizeUrl,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The provider's token server URL.")]
        [System.Uri]
        $TokenUrl,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The provider's user info server URL.")]
        [System.Uri]
        $UserinfoUrl,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The Client ID assigned to mailcow Client in OIDC provider.")]
        [System.String]
        $ClientId,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The Client Secret assigned to the mailcow client in OIDC provider.")]
        [System.Security.SecureString]
        $ClientSecret,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The redirect URL that OIDC provider will use after authentication. This should point to your mailcow UI.")]
        [System.Uri]
        $RedirectUrl,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Additional redirect URL.")]
        [System.Uri[]]
        $RedirectUrlExtra,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Specifies the OIDC scopes requested during authentication.")]
        [System.String[]]
        $ClientScope = @("openid", "profile", "email", "mailcow_template"),

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation is bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/identity-provider"
    }

    process {
        # Get current configuration and use it as base. This allows to update only specific attributes and keep all other settings as is.
        $CurrentGenericOIDCConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "generic-oidc" }
        if ($null -ne $CurrentGenericOIDCConfig) {
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentGenericOIDCConfig
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "generic-oidc"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("AuthorizeUrl")) {
            $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("TokenUrl")) {
            $Body.attr.token_url = $TokenUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("UserinfoUrl")) {
            $Body.attr.userinfo_url = $UserinfoUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("ClientId")) {
            $Body.attr.client_id = $ClientId.Trim()
        }
        if ($PSBoundParameters.ContainsKey("ClientSecret")) {
            $Body.attr.client_secret = $ClientSecret | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrl")) {
            $Body.attr.redirect_url = $RedirectUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrlExtra")) {
            $Body.attr.redirect_url_extra = $RedirectUrlExtra.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("ClientScope")) {
            $Body.attr.client_scopes = $ClientScope
        }
        if ($PSBoundParameters.ContainsKey("DefaultTemplate")) {
            $Body.attr.default_template = $DefaultTemplate
        }
        if ($PSBoundParameters.ContainsKey("AttributeMapping")) {
            $Body.attr.mappers = $AttributeMapping.Keys
            $Body.attr.templates = $AttributeMapping.Values
        }
        if ($PSBoundParameters.ContainsKey("IgnoreSslError")) {
            $Body.attr.ignore_ssl_error = if ($IgnoreSslError.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.Keys) {
            if ($CurrentGenericOIDCConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentGenericOIDCConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentGenericOIDCConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentGenericOIDCConfig.$Key)] to [$($Body.attr.$Key)]."
                    $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("OIDC Identity Provider configuration", "Update")) {
            Write-MailcowHelperLog -Message "Updateing OIDC Identity Provider configuration." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            if ($Result.type -eq "danger" -and $Result.msg -contains "authsource_in_use") {
                # The error "authsource_in_use" means that currently another authentiation source / identity provider is configured and used by at least one mailbox.
                Write-MailcowHelperLog -Message "Currently another authentiation source / identity provider is configured and used by at least one mailbox." -Level Warning
            }
            $Result
        }
    }
}

function Set-IdPKeycloak {
    <#
    .SYNOPSIS
        Updates settings for a Keycloak auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a Keycloak auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a Keycloak identity provider as auth source in mailcow.

    .PARAMETER ServerUrl
        The base URL of the Keycloak server.

    .PARAMETER Realm
        The Keycloak realm where the mailcow client is configured.

    .PARAMETER ClientId
        The Client ID assigned to mailcow Client in Keycloak.

    .PARAMETER ClientSecret
        The Client Secret assigned to the mailcow client in Keycloak.

    .PARAMETER RedirectUrl
        The redirect URL that Keycloak will use after authentication. This should point to your mailcow UI.

    .PARAMETER RedirectUrlExtra
        Additional redirect URL.

    .PARAMETER Version
        Specifies the Keycloak version.

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation is bypassed.

    .PARAMETER MailpasswordFlow
        If enabled, mailcow will attempt to validate user credentials using the Keycloak Admin REST API instead of relying solely on the Authorization Code Flow.

    .PARAMETER PeriodicSync
        If enabled, mailcow periodically performs a full sync of all users from Keycloak.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .PARAMETER ImportUsers
        If enabled, new users are automatically imported from Keycloak into mailcow.

    .PARAMETER SyncInterval
        Defines the time interval (in minutes) for periodic synchronization and user imports.

    .EXAMPLE
        $ClientSecret = Read-Host -AsSecureString

        Set-MHIdPKeycloak -ServerUrl "https://auth.mailcow.tld" -RedirectUrl "https://mail.mailcow.tld" -Realm "mailcow" -ClientID "mailcow_client" -Version "26.1.3"

        Prompts for the client secret and stores in the variable $ClientSecret as secure string.
        Configures settings for using Keycloak as identity provider in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdPKeycloak.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The base URL of the Keycloak server.")]
        [System.Uri]
        $ServerUrl,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The Keycloak realm where the mailcow client is configured.")]
        [System.String]
        $Realm,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The Client ID assigned to mailcow Client in Keycloak.")]
        [System.String]
        $ClientId,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The Client Secret assigned to the mailcow client in Keycloak.")]
        [System.Security.SecureString]
        $ClientSecret,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The redirect URL that Keycloak will use after authentication. This should point to your mailcow UI.")]
        [System.Uri]
        $RedirectUrl,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Additional redirect URL.")]
        [System.Uri[]]
        $RedirectUrlExtra,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Specifies the Keycloak version.")]
        [System.String]
        $Version,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation is bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "If enabled, mailcow will attempt to validate user credentials using the Keycloak Admin REST API instead of relying solely on the Authorization Code Flow.")]
        [System.Management.Automation.SwitchParameter]
        $MailpasswordFlow,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "If enabled, mailcow periodically performs a full sync of all users from Keycloak.")]
        [System.Management.Automation.SwitchParameter]
        $PeriodicSync,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "If enabled, new users are automatically imported from Keycloak into mailcow.")]
        [System.Management.Automation.SwitchParameter]
        $ImportUsers,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Defines the time interval (in minutes) for periodic synchronization and user imports.")]
        [System.Int32]
        [ValidateRange(1, 1440)]
        $SyncInterval = 15
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/identity-provider"
    }

    process {
        # Get current configuration and use it as base. This allows to update only specific attributes and keep all other settings as is.
        $CurrentKeycloakConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "keycloak" }
        if ($null -ne $CurrentKeycloakConfig) {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentKeycloakConfig
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "keycloak"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("ServerUrl")) {
            $Body.attr.server_url = $ServerUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("Realm")) {
            $Body.attr.realm = $Realm.Trim()
        }
        if ($PSBoundParameters.ContainsKey("ClientId")) {
            $Body.attr.client_id = $ClientId.Trim()
        }
        if ($PSBoundParameters.ContainsKey("ClientSecret")) {
            $Body.attr.client_secret = $ClientSecret | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrl")) {
            $Body.attr.redirect_url = $RedirectUrl.AbsoluteUri
        }
        if ($PSBoundParameters.ContainsKey("RedirectUrlExtra")) {
            $Body.attr.redirect_url_extra = foreach ($RedirectUrlExtraItem in $RedirectUrlExtra) { $RedirectUrlExtraItem.AbsoluteUri }
        }
        if ($PSBoundParameters.ContainsKey("Version")) {
            $Body.attr.version = $Version.Trim()
        }
        if ($PSBoundParameters.ContainsKey("DefaultTemplate")) {
            $Body.attr.default_template = $DefaultTemplate
        }
        if ($PSBoundParameters.ContainsKey("AttributeMapping")) {
            $Body.attr.mappers = $AttributeMapping.Keys
            $Body.attr.templates = $AttributeMapping.Values
        }
        if ($PSBoundParameters.ContainsKey("IgnoreSslError")) {
            $Body.attr.ignore_ssl_error = if ($IgnoreSslError.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MailpasswordFlow")) {
            $Body.attr.mailpassword_flow = if ($MailpasswordFlow.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PeriodicSync")) {
            $Body.attr.periodic_sync = if ($PeriodicSync.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImportUsers")) {
            $Body.attr.import_users = if ($ImportUsers.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SyncInterval")) {
            $Body.attr.sync_interval = $SyncInterval.ToString()
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.Keys) {
            if ($CurrentKeycloakConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentKeycloakConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentKeycloakConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentKeycloakConfig.$Key)] to [$($Body.attr.$Key)]."
                    $Body.attr.authorize_url = $AuthorizeUrl.AbsoluteUri
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("Keycloak Identity Provider configuration.", "Update")) {
            Write-MailcowHelperLog -Message "Updating Keycloak Identity Provider configuration." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            if ($Result.type -eq "danger" -and $Result.msg -contains "authsource_in_use") {
                # The error "authsource_in_use" means that currently another authentiation source / identity provider is configured and used by at least one mailbox.
                Write-MailcowHelperLog -Message "Currently another authentiation source / identity provider is configured and used by at least one mailbox." -Level Warning
            }
            $Result
        }
    }
}

function Set-IdpLdap {
    <#
    .SYNOPSIS
        Updates settings for a LDAP auth source as an external identity provider in mailcow.

    .DESCRIPTION
        Updates settings for a LDAP auth source as an external identity provider in mailcow.
        In addition to the mailcow internal authentication, mailcow supports three external types of identity providers: Generic OIDC, Keycloak and LDAP.
        Only one identity provider can be active.
        This function allows to configure settings for a LDAP identity providera as auth source in mailcow.

    .PARAMETER Hostname
        The name or IP address of a LDAP host. Supports multiple values.

    .PARAMETER Port
        The port used to connect to the LDAP server. Defaults to port 389.

    .PARAMETER UseSsl
        Enable or disable LDAPS. If port 389 is specified, enabling SSL will automatically use port 636 instead.

    .PARAMETER UseStartTls
        Enable or disable StartTLS. SSL Ports cannot be used.

    .PARAMETER IgnoreSslError
        If enabled, SSL certificate validation will be bypassed.

    .PARAMETER BaseDN
        The Distinguished Name (DN) from which searches will be performed.

    .PARAMETER UsernameField
        The LDAP attribute used to identify users during authentication.

    .PARAMETER LdapFilter
        An optional LDAP search filter to refine which users can authenticate.

    .PARAMETER AttributeField
        The name of the LDAP attribute in which to lookup the value defined in the attribute mapping.

    .PARAMETER BindDN
        The Distinguished Name (DN) of the LDAP user that will be used to authenticate and perform LDAP searches.
        This account should have sufficient permissions to read the required attributes.

    .PARAMETER BindPassword
        The password for the Bind DN user. It is required for authentication when connecting to the LDAP server.

    .PARAMETER DefaultTemplate
        The name of the default template to use for creating a mailbox.

    .PARAMETER AttributeMapping
        Specify an attribute value as key and a mailbox template name as value.

    .PARAMETER PeriodicSync
        If enabled, a full synchronization of all LDAP users and attributes will be performed periodically.

    .PARAMETER LoginProvisioning
        Provision mailcow mailbox on user login.

    .PARAMETER ImportUsers
        If enabled, new users will be automatically imported from LDAP into mailcow.

    .PARAMETER SyncInterval
        Defines the time interval (in minutes) for periodic synchronization and user imports.

    .EXAMPLE
        Set-MHIdpLdap -Hostname 1.2.3.4, 5.6.7.8 -UseSsl

        Sets LDAP servers with IP addresses 1.2.3.4 and 5.6.7.8 and enables the usage of SSL.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-IdpLdap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The name or IP address of a LDAP host.")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The port used to connect to the LDAP server.")]
        [ValidateRange(1, 65535)]
        $Port = 389,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enable or disable LDAPS. If port 389 is specified, enabling SSL will automatically use port 636 instead.")]
        [System.Management.Automation.SwitchParameter]
        $UseSsl,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable StartTLS. SSL Ports cannot be used.")]
        [System.Management.Automation.SwitchParameter]
        $UseStartTls,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If enabled, SSL certificate validation will be bypassed.")]
        [System.Management.Automation.SwitchParameter]
        $IgnoreSslError,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The Distinguished Name (DN) from which searches will be performed.")]
        [System.String]
        $BaseDN,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The LDAP attribute used to identify users during authentication.")]
        [System.String]
        $UsernameField = "mail",

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "An optional LDAP search filter to refine which users can authenticate.")]
        [System.String]
        $LdapFilter = "(&(objectClass=user)",

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The name of the LDAP attribute in which to lookup the value defined in the attribute mapping.")]
        [System.String]
        $AttributeField = "othermailbox",

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "The Distinguished Name (DN) of the LDAP user that will be used to authenticate and perform LDAP searches.")]
        [System.String]
        $BindDN,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "The password for the Bind DN user. It is required for authentication when connecting to the LDAP server.")]
        [System.Security.SecureString]
        $BindPassword,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "The name of the default template to use for creating a mailbox.")]
        [System.String]
        $DefaultTemplate = "Default",

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Specify an attribute value as key and a mailbox template name as value.")]
        [System.Collections.Hashtable]
        $AttributeMapping,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "If enabled, a full synchronization of all LDAP users and attributes will be performed periodically.")]
        [System.Management.Automation.SwitchParameter]
        $PeriodicSync,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Provision mailcow mailbox on user login.")]
        [System.Management.Automation.SwitchParameter]
        $LoginProvisioning,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "If enabled, new users will be automatically imported from LDAP into mailcow.")]
        [System.Management.Automation.SwitchParameter]
        $ImportUsers,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Defines the time interval (in minutes) for periodic synchronization and user imports.")]
        [System.Int32]
        [ValidateRange(1, 1440)]
        $SyncInterval = 15
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/identity-provider"
    }

    process {
        # Get current configuration and use it as base. This allows to update only specific attributes and keep all other settings as is.
        $CurrentLdapConfig = Get-IdentityProvider -Raw | Where-Object { $_.authsource -eq "ldap" }

        if ($null -ne $CurrentLdapConfig) {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                # Set the new config to be the same as the current config. Changes will be done below for whatever was specified by parameters.
                attr  = $CurrentLdapConfig | ConvertTo-Json | ConvertFrom-Json
            }
        }
        else {
            # Prepare the request body.
            $Body = @{
                items = "identity-provider"
                attr  = @{
                    authsource = "ldap"
                }
            }
        }

        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.host = $Hostname.Trim() -join ","
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("BaseDN")) {
            $Body.attr.basedn = $BaseDN.Trim()
        }
        if ($PSBoundParameters.ContainsKey("UsernameField")) {
            $Body.attr.username_field = $UsernameField.Trim()
        }
        if ($PSBoundParameters.ContainsKey("LdapFilter")) {
            $Body.attr.filter = $LdapFilter.Trim()
        }
        if ($PSBoundParameters.ContainsKey("AttributeField")) {
            $Body.attr.attribute_field = $AttributeField.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BindDN")) {
            $Body.attr.binddn = $BindDN.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BindPassword")) {
            $Body.attr.bindpass = $BindPassword | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("DefaultTemplate")) {
            $Body.attr.default_template = $DefaultTemplate
        }
        if ($PSBoundParameters.ContainsKey("UseSsl")) {
            $Body.attr.use_ssl = if ($UseSsl.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("UseStartTls")) {
            $Body.attr.use_tls = if ($UseStartTls.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("IgnoreSslError")) {
            $Body.attr.ignore_ssl_error = if ($IgnoreSslError.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("PeriodicSync")) {
            $Body.attr.periodic_sync = if ($PeriodicSync.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("LoginProvisioning")) {
            $Body.attr.login_provisioning = if ($LoginProvisioning.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImportUsers")) {
            $Body.attr.import_users = $ImportUsers.IsPresent
        }
        if ($PSBoundParameters.ContainsKey("SyncInterval")) {
            $Body.attr.sync_interval = $SyncInterval.ToString()
        }
        if ($PSBoundParameters.ContainsKey("AttributeMapping")) {
            $Body.attr.mappers = $AttributeMapping.Keys
            $Body.attr.templates = $AttributeMapping.Values
        }

        # Compare attribute values from current config with updated config and report what has changed.
        foreach ($Key in $Body.attr.PSObject.Properties.Name) {
            if ($CurrentLdapConfig.PSObject.Properties.Name -contains $Key) {
                if ($CurrentLdapConfig.$Key -eq $Body.attr.$Key) {
                    Write-MailcowHelperLog -Message "No need to update value for attribute [$Key] because it's already set to the specified value [$($CurrentLdapConfig.$Key)]."
                }
                else {
                    Write-MailcowHelperLog -Message "Updating the value for attribute [$Key] from [$($CurrentLdapConfig.$Key)] to [$($Body.attr.$Key)]."
                }
            }
            else {
                Write-MailcowHelperLog -Message "Attribute not found in base [$Key]. Setting it to value [$($Body.attr.$Key)]."
            }
        }

        if ($PSCmdlet.ShouldProcess("LDAP Identity Provider configuration.", "Update")) {
            Write-MailcowHelperLog -Message "Updateing LDAP Identity Provider configuration." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            if ($Result.type -eq "danger" -and $Result.msg -contains "authsource_in_use") {
                # The error "authsource_in_use" means that currently another authentiation source / identity provider is configured and used by at least one mailbox.
                Write-MailcowHelperLog -Message "Currently another authentiation source / identity provider is configured and used by at least one mailbox." -Level Warning
            }
            $Result
        }
    }
}

function Set-Mailbox {
    <#
    .SYNOPSIS
        Update settings for one or more mailboxes.

    .DESCRIPTION
        Update settings for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox to update.

    .PARAMETER Name
        The display name of the mailbox.

    .PARAMETER AuthSource
        The authentication source to use. Default is "mailcow".
        Suppored values are: "mailcow", "LDAP", "Keycloak" and "Generic-OIDC".

    .PARAMETER Password
        The password for the new mailbox user.

    .PARAMETER ActiveState
        The mailbox state. Valid values are:
        Active = Mails to the mail address are accepted, the account is enabled, so login is possible.
        DisallowLogin = Mails to the mail address are accepted, the account is disabled, so login is denied.
        Inactive = Mails to the mail address are rejected, the account is disabled, so login is denied.

    .PARAMETER MailboxQuota
        The mailbox quota in MB.
        If ommitted, the domain default mailbox quota will be applied.

    .PARAMETER Tag
        Add one or more tags to the mailbox, whicht can be used for filtering.

    .PARAMETER SogoAccess
        Direct forwarding to SOGo.
        After logging in, the user is automatically redirected to SOGo.

    .PARAMETER ImapAccess
        Enable or disable IMAP for the user.

    .PARAMETER Pop3Access
        Enable or disable POP3 for the user.

    .PARAMETER SmtpAccess
        Enable or disable SMTP for the user.

    .PARAMETER SieveAccess
        Enable or disable Sieve for the user.

    .PARAMETER EasAccess
        Enable or disable EAS (Exchange Active Sync) for the user.

    .PARAMETER DavAccess
        Enable or disable CalDAV/CardDAV for the user.

    .PARAMETER RelayHostId
        Set a specific relay host. Use 'Get-RoutingRelayHost' to get the configured relay hosts and their IDs.

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER RecoveryEmail
        Specify an email address that will be used for password recovery.

    .PARAMETER QuarantineNotification
        The notificatoin interval.
        Valid values are Never, Hourly, Daily, Weekly.

    .PARAMETER QuarantineCategory
        The notificatoin category.
        Valid values are Rejected, Junk folder, All categories.

    .PARAMETER TaggedMailAction
        Specify the action for tagged mail.
        Valid values are: Subject, Subfolder, Nothing

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections.

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -Name "John Doe" -MailboxQuota 10240

        Set the name for mailbox "john.doe@example.com" and also set the mailbox quota to 10 GByte.

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -ForcePasswordUpdate

        Force password change on next logon for user "john.doe@example.com".

    .EXAMPLE
        Set-MHMailbox -Identity "john.doe@example.com" -EasAccess:$false

        Disable EAS protocol for the mailbox of user "john.doe@example.com".

    .EXAMPLE
        $DisabledMailboxes = (Get-ADUser -Filter {mail -like "*" -and Enabled -eq $false} -Properties mail).mail | Set-MHMailbox -ActiveState Inactive

        In an environment where Active Directory/LDAP is used as identity provider for mailcow, the example above shows how to get all disabled user accounts
        from Active Directory and send the output down the pipeline to the 'Set-MHMailbox' function to disable the mailbox in mailcow.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Mailbox.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to update.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The display name of the mailbox.")]
        [System.String]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The authentication source to use. Default is 'mailcow'.")]
        [ValidateSet("mailcow", "LDAP", "Keycloak", "Generic-OIDC")]
        [System.String]
        $AuthSource,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The password for the mailbox user.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The mailbox quota in MB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota = 3072,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Add one or more tags to the mailbox, which can be used for filtering.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "The ID of the relay host to use for the mailbox.")]
        [System.Int32]
        $RelayHostId,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Set the password recovery mail address for the mailbox.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $RecoveryEmail,

        [Parameter(Position = 17, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuarantineNotification = "Hourly",

        [Parameter(Position = 18, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuarantineCategory = "Rejected",

        [Parameter(Position = 19, Mandatory = $false, HelpMessage = "The action to take for plus-tagged mails.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailAction,

        [Parameter(Position = 20, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 21, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Set name to the local part of th mail address, if it was not specified explicitly.
        if (-not $PSBoundParameters.ContainsKey("Name")) {
            $Name = $Identity.User
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("ActiveState")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting mailbox to state [$ActiveState]."
            $Body.attr.active = "$($ActiveState.value__)"
        }
        if ($PSBoundParameters.ContainsKey("Name")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the mailbox name to [$($Name.Trim())]."
            $Body.attr.name = $Name.Trim()
        }
        if ($PSBoundParameters.ContainsKey("AuthSource")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the auth source for mailbox to [$($AuthSource)]."
            $Body.attr.authsource = $AuthSource.Tolower()
        }
        if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting the mailbox quota for mailbox to [$($MailboxQuota)]."
            $Body.attr.quota = $MailboxQuota.ToString()
        }
        if ($PSBoundParameters.ContainsKey("SogoAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable SOGo direct forward for mailbox --> [$($SogoAccess.IsPresent)]."
            $Body.attr.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("ImapAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable IMAP for mailbox --> [$($ImapAccess.IsPresent)]."
            $Body.attr.imap_access = if ($ImapAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Pop3Access")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable POP3 for mailbox --> [$($Pop3Access.IsPresent)]."
            $Body.attr.pop3_access = if ($Pop3Access.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SmtpAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable SMTP for mailbox --> [$($SmtpAccess.IsPresent)]."
            $Body.attr.smtp_access = if ($SmtpAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SieveAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable Sieve for mailbox --> [$($SieveAccess.IsPresent)]."
            $Body.attr.sieve_access = if ($SieveAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("EasAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable EAS for mailbox --> [$($EasAccess.IsPresent)]."
            $Body.attr.eas_access = if ($EasAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DavAccess")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Enable Cal/CardDAV for mailbox --> [$($DavAccess.IsPresent)]."
            $Body.attr.dav_access = if ($DavAccess.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("RelayHostId")) {
            # Set the relay host for the mailbox.
            Write-MailcowHelperLog -Message "[$LogIdString] Setting relay host for mailbox to ID [$RelayHostId]."
            $Body.attr.relayhost = $RelayHostId
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            # Set the password and the password confirmation value to the entered password.
            Write-MailcowHelperLog -Message "[$LogIdString] Setting password for mailbox."
            $Body.attr.password = $Body.password2 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Force password updatefor mailbox --> [$($ForcePasswordUpdate.IsPresent)]."
            $Body.attr.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
        }
        if (-not [System.String]::IsNullOrEmpty($Tag)) {
            Write-MailcowHelperLog -Message "[$LogIdString] Setting mailbox tags to [$($Tag -join ",")]."
            $Body.attr.tags = $Tag
        }
        if ($PSBoundParameters.ContainsKey("RecoveryEmail")) {
            if ([System.String]::IsNullOrEmpty($RecoveryEmail)) {
                Write-MailcowHelperLog -Message "[$LogIdString] Removing password recovery email address."
                $Body.attr.pw_recovery_email = ""
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Setting password recovery email address to [$($RecoveryEmail.Address))]."
                $Body.attr.pw_recovery_email = $RecoveryEmail.Address
            }
        }
        if ($PSBoundParameters.ContainsKey("QuarantineNotification")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "quarantine_notification".
            $SetMailboxQuarantineNotificationParams = @{
                Identity                 = $Identity
                QuaranantineNotification = $QuarantineNotification
            }
            Set-MailboxQuarantineNotification @SetMailboxQuarantineNotificationParams
        }
        if ($PSBoundParameters.ContainsKey("QuarantineCategory")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "quarantine_category".
            $SetMailboxQuarantineNotificationCategoryParams = @{
                Identity             = $Identity
                QuaranantineCategory = $QuarantineCategory
            }
            Set-MailboxQuarantineNotificationCategory @SetMailboxQuarantineNotificationCategoryParams
        }
        if ($PSBoundParameters.ContainsKey("TaggedMailAction")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "delimiter_action".
            $SetMailboxTaggedMailHandlingParams = @{
                Identity         = $Identity
                TaggedMailAction = $TaggedMailAction
            }
            Set-MailboxTaggedMailHandling @SetMailboxTaggedMailHandlingParams
        }
        if ($PSBoundParameters.ContainsKey("EnforceTlsIn") -or $PSBoundParameters.ContainsKey("EnforceTlsOut")) {
            # Call another function because the "edit/mailbox" API endpoint does not support the option "delimiter_action".
            $SetMHMailboxTlsPolicyParams = @{
                Identity = $Identity
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $SetMHMailboxTlsPolicyParams.EnforceTlsIn = $EnforceTlsIn
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $SetMHMailboxTlsPolicyParams.EnforceTlsOut = $EnforceTlsOut
            }
            Set-MHMailboxTlsPolicy @SetMHMailboxTlsPolicyParams
        }

        if ($PSCmdlet.ShouldProcess("mailbox settings for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "[$LogIdString] Updating mailbox settings." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxCustomAttribute {
    <#
    .SYNOPSIS
        Updates custom attributes for one or more mailboxes.

    .DESCRIPTION
        Updates custom attributes for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to update custom attributes.

    .PARAMETER AttributeValuePair
        The key value pair to set as custom attribute. Expects a hashtable.

    .EXAMPLE
        Set-MHMailboxCustomAttribute -Identity "user123@example.com" -AttributeValuePair @{VIPUser = "1"}

        Adds the custom attribute name "VIPuser" with value "1" on the mailbox of "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxCustomAttribute.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true)]
        [System.Collections.Hashtable]
        $AttributeValuePair
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox/custom-attribute"
    }

    process {
        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                attribute = $AttributeValuePair.Keys
                value     = $AttributeValuePair.Values
            }
        }

        Write-Warning -Message "CAUTION: Setting custom attributes will overwrite any existing attributes for the specified mailbox!"

        if ($PSCmdlet.ShouldProcess("custom mailbox attributes for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating custom mailbox attributes for [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxPushover {
    <#
    .SYNOPSIS
        Updates Pushover notification settings for one or more mailboxes.

    .DESCRIPTION
        Updates Pushover notification settings for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which Pushover settings should be configured.

    .PARAMETER Token
        The Pushover API application token.

    .PARAMETER Key
        The Pushover user or group key.

    .PARAMETER Title
        The notification title sent via Pushover.

    .PARAMETER Text
        The notification body text sent via Pushover.

    .PARAMETER SenderMailAddress
        One or more sender email addresses that should trigger a Pushover notification.

    .PARAMETER Sound
        Specifies the notification sound to play. Must be one of the predefined Pushover sound names.
        Defaults to "Pushover".

    .PARAMETER SenderRegex
        Specifies a regular expression used to match sender addresses for triggering notifications.

    .PARAMETER EvaluateXPrio
        If specified, high-priority messages (X-Priority headers) are evaluated and escalated.

    .PARAMETER OnlyXPrio
        If specified, only high-priority messages (X-Priority headers) are considered for notifications.

    .PARAMETER Enable
        Enables or disables Pushover notifications for the mailbox.

    .EXAMPLE
        Set-MHMailboxPushover -Identity "user@example.com" -Token "APP_TOKEN" -Key "USER_KEY" -Enable

        Enables Pushover notifications for the specified mailbox using the provided token and key.

    .EXAMPLE
        "user123@example.com", "user456@example.com" | Set-MHMailboxPushover -Enable -Sound "Magic"

        Enables Pushover notifications for multiple mailboxes piped into the function and sets the
        notification sound to "Magic".

    .EXAMPLE
        Set-MHMailboxPushover -Identity "alerts@example.com" -SenderRegex ".*@critical\.com" -EvaluateXPrio -Enable

        Enables notifications only for senders matching the regex and escalates high-priority messages.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxPushover.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which Pushover settings should be configured.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The Pushover API Token/Key (Application).")]
        [System.String]
        $Token,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The Pushover User/Group Key.")]
        [System.String]
        $Key,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The notification title.")]
        [System.String]
        $Title,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The notification text.")]
        [System.String]
        $Text,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Sender email address to consider.")]
        [System.Net.Mail.MailAddress[]]
        $SenderMailAddress,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The sound to play.")]
        [ValidateSet("Pushover", "Bike", "Bugle", "Cash Register", "Classical", "Cosmic", "Falling", "Gamelan", "Incoming", "Intermission", "Magic", "Mechanical", "Piano Bar", "Siren", "Space Alarm", "Tug Boat", "Aliean alarm", "Climb", "Persistent", "Pushover Echo", "Up Down", "Vibrate Only", "None")]
        [System.String]
        $Sound = "Pushover",

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Sender regex string to consider.")]
        [System.String]
        $SenderRegex,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "Escalate high priority mail.")]
        [System.Management.Automation.SwitchParameter]
        $EvaluateXPrio,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Only consider high priority mail.")]
        [System.Management.Automation.SwitchParameter]
        $OnlyXPrio,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enable or disable the pushover settings.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/pushover"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Token")) {
            $Body.attr.token = $Token
        }
        if ($PSBoundParameters.ContainsKey("Key")) {
            $Body.attr.key = $Key
        }
        if ($PSBoundParameters.ContainsKey("Title")) {
            $Body.attr.title = $Title
        }
        if ($PSBoundParameters.ContainsKey("Text")) {
            $Body.attr.text = $Text
        }
        if ($PSBoundParameters.ContainsKey("SenderMailAddress")) {
            $Body.attr.senders = foreach ($SenderMailAddressItem in $SenderMailAddress) {
                $SenderMailAddressItem.Address
            }
        }
        if ($PSBoundParameters.ContainsKey("Sound")) {
            $Body.attr.sound = $Sound.ToLower()
        }
        if ($PSBoundParameters.ContainsKey("SenderRegex")) {
            $Body.attr.senders_regex = $SenderRegex
        }
        if ($PSBoundParameters.ContainsKey("EvaluateXPrio")) {
            $Body.attr.evaluate_x_prio = if ($EvaluateXPrio.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("OnlyXPrio")) {
            $Body.attr.only_x_prio = if ($OnlyXPrio.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailbox Pushover settings for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating pushover settings for [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxQuarantineNotification {
    <#
    .SYNOPSIS
        Updates the quarantine notfication interval for one or more mailboxes.

    .DESCRIPTION
        Updates the quarantine notfication interval for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the quarantine notification interval.

    .PARAMETER QuaranantineNotification
        The notificatoin interval.
        Valid values are Never, Hourly, Daily, Weekly.

    .EXAMPLE
        Set-MHMailboxQuarantineNotification -Identity "user123@example.com" -QuaranantineNotification "Daily"

        Set the notification period to "Daily" for the mailbox of the user "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the quarantine notification interval.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuaranantineNotification
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/quarantine_notification"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                quarantine_notification = $QuaranantineNotification.ToLower()
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox quarantine notification interval for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "Updating quarantine notification interval for [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxQuarantineNotificationCategory {
    <#
    .SYNOPSIS
        Updates the quarantine notfication interval for one or more mailboxes.

    .DESCRIPTION
        Updates the quarantine notfication interval for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for want to set the quarantine notification category.

    .PARAMETER QuaranantineCategory
        The notificatoin category.
        Valid values are Rejected, Junk folder, All categories.

    .EXAMPLE
        Set-MHMailboxQuarantineNotificationCategory -Identity "user123@example.com" QuaranantineCategory "All categories"

        Set the notification category to "All categories" for the mailbox of the user "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for want to set the quarantine notification category.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuaranantineCategory
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/quarantine_category"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                quarantine_category = switch ($QuaranantineCategory) {
                    "Rejected" {
                        "reject"
                        break
                    }
                    "Junk folder" {
                        "add_header"
                        break
                    }
                    default {
                        # "All categories"
                        "all"
                    }
                }
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox quarantine notification category for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating quarantine notification category for [$LogIdString]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxSpamScore {
    <#
    .SYNOPSIS
        Updates the spam score for one or more mailboxes.

    .DESCRIPTION
        Updates the spam score for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the spam score.

    .PARAMETER SpamScoreLow
        The low spam score value.

    .PARAMETER SpamScoreHigh
        The high spam score value.

    .EXAMPLE
        Set-MHMailboxSpamScore -Identity "user123@example.com" -SpamScoreLow 7 -SpamScoreHigh 14

        Set the low and high spam score values for mailbox "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxSpamScore.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the spam score.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The low spam score value.")]
        [ValidateRange(0, 5000)]
        [System.Int32]
        $SpamScoreLow = 8,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The high spam score value.")]
        [ValidateRange(0, 5000)]
        [System.Int32]
        $SpamScoreHigh = 15
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/spam-score"

        if ($SpamScoreLow -gt $SpamScoreHigh) {
            Write-MailcowHelperLog -Message "Spam score low level can not be greater the spam score high level." -Level Warning
            break
        }
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                spam_score = "$SpamScoreLow,$SpamScoreHigh"
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox spam score for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox spam score for [$LogIdString]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxTaggedMailHandling {
    <#
    .SYNOPSIS
        Updates plus-tagged mail handling for one or more mailboxes.

    .DESCRIPTION
        Updates plus-tagged mail handling for one or more mailboxes.

        In subfolder: a new subfolder named after the tag will be created below INBOX ("INBOX/Newsletter").
        In subject: the tags name will be prepended to the mails subject, example: "[Newsletter] My News".
        Do nothing: no special handling for tagged mail.

        Example for a tagged email address: me+Newsletter@example.org

    .PARAMETER Identity
        The mail address of the mailbox for which to update plus-tagged mail handling.

    .PARAMETER Action
        Specify the action for tagged mail.
        Valid values are: Subject, Subfolder, Nothing

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subfolder

        This will move tagged mails to a subfolder named after the tag.

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Subject

        This will prepand the the tags name to the subject of the mail.

    .EXAMPLE
        Set-MHMailboxTaggedMailHandling -Identity "user123@example.com" -Action Nothing

        This will do nothing extra for plus-tagged mail. Mail gets delivered to the inbox.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTaggedMailHandling.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to update plus-tagged mail handling.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "Specify the action for plus-tagged mails.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [Alias("TaggedMailAction", "DelimiterAction")]
        [System.String]
        $Action
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/delimiter_action"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{
                tagged_mail_handler = $Action.ToLower()
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox tagged mail action for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating tagged mail action for [$LogIdString]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxTemplate {
    <#
    .SYNOPSIS
        Updates one or more mailbox templates.

    .DESCRIPTION
        Updates one or more mailbox templates.
        A mailbox template can either be specified as a default template for a domain.
        Or you can select a template when creating a new mailbox to inherit some properties.

    .PARAMETER Name
        The name of the mailbox template.

    .PARAMETER MailboxQuota
        The mailbox quota limit in MiB.

    .PARAMETER Tag
        One or more tags to will be assigned to a mailbox.

    .PARAMETER TaggedMailHandler
        The action to execute for tagged mail.

    .PARAMETER QuaranantineNotification
        The notification interval.

    .PARAMETER QuaranantineCategory
        The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.

    .PARAMETER RateLimitValue
        The rate limit value.

    .PARAMETER RateLimitFrame
        The rate limit unit.

    .PARAMETER ActiveState
        The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.

    .PARAMETER ForcePasswordUpdate
        Force a password change for the user on the next logon.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections for this mailbox.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections from this mailbox.

    .PARAMETER SogoAccess
        Enable or disable access to SOGo for the user.

    .PARAMETER ImapAccess
        Enable or disable IMAP for the user.

    .PARAMETER Pop3Access
        Enable or disable POP3 for the user.

    .PARAMETER SmtpAccess
        Enable or disable SMTP for the user.

    .PARAMETER SieveAccess
        Enable or disable Sieve for the user.

    .PARAMETER EasAccess
        Enable or disable Exchange Active Sync for the user.

    .PARAMETER DavAccess
        Enable or disable CalDAV/CardDav for the user.

    .PARAMETER AclManageAppPassword
        Allow to manage app passwords.

    .PARAMETER AclDelimiterAction
        Allow Delimiter Action.

    .PARAMETER AclResetEasDevice
        Allow to reset EAS device.

    .PARAMETER AclPushover
        Allow Pushover.

    .PARAMETER AclQuarantineAction
        Allow quarantine action.

    .PARAMETER AclQuarantineAttachment
        Allow quarantine attachement.

    .PARAMETER AclQuarantineNotification
        Allow to change quarantine notification.

    .PARAMETER AclQuarantineNotificationCategory
        Allow to change quarantine notification category.

    .PARAMETER AclSOGoProfileReset
        Allow to reset the SOGo profile.

    .PARAMETER AclTemporaryAlias
        Allow to manage temporary alias.

    .PARAMETER AclSpamPolicy
        Allow to manage SPAM policy.

    .PARAMETER AclSpamScore
        Allow to manage SPAM score.

    .PARAMETER AclSyncJob
        Allow to manage sync job.

    .PARAMETER AclTlsPolicy
        Allow to manage TLS policy.

    .PARAMETER AclPasswordReset
        Allow to reset the user password.

    .EXAMPLE
        Set-MHMailboxTemplate -Name "ExampleTemplate"

        This creates a new mailbox template using default values for all parameters.

    .EXAMPLE
        Set-MHMailboxTemplate -Name "ExampleTemplate" -MailboxQuota 10240 -RateLimitValue 5 -RateLimitFrame Minute

        This creates a new mailbox template allowing a maximum of 10 GByte per mailbox and allowing maximum of 5 mails per minute.

    .INPUTS
        System.Int64[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxTemplate.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The ID value of the mailbox template to update.")]
        [System.Int64[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The new name of the mailbox template.")]
        [System.Int64]
        $Name,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The mailbox quota limit in MiB.")]
        [ValidateRange(0, 2147483647)]
        [System.Int32]
        $MailboxQuota,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "One or more tags to will be assigned to a mailbox.")]
        [System.String[]]
        $Tag,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The action to execute for tagged mail.")]
        [ValidateSet("Subject", "Subfolder", "Nothing")]
        [System.String]
        $TaggedMailHandler,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The notification interval.")]
        [ValidateSet("Never", "Hourly", "Daily", "Weekly")]
        [System.String]
        $QuaranantineNotification,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The notification category. 'Rejected' includes mail that was rejected, while 'Junk folder' will notify a user about mails that were put into the junk folder.")]
        [ValidateSet("Rejected", "Junk folder", "All categories")]
        [System.String]
        $QuaranantineCategory,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "The rate limit value.")]
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "The rate limit unit.")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame,

        [Parameter(Position = 8, Mandatory = $false, HelpMessage = "The mailbox state. Valid values are 'Active', 'Inactive', 'DisallowLogin'.")]
        [MailcowHelperMailboxActiveState]
        $ActiveState,

        [Parameter(Position = 9, Mandatory = $false, HelpMessage = "Force a password change for the user on the next logon.")]
        [System.Management.Automation.SwitchParameter]
        $ForcePasswordUpdate,

        [Parameter(Position = 10, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 11, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut,

        [Parameter(Position = 12, Mandatory = $false, HelpMessage = "Enable or disable access to SOGo for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SogoAccess,

        [Parameter(Position = 13, Mandatory = $false, HelpMessage = "Enable or disable IMAP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $ImapAccess,

        [Parameter(Position = 14, Mandatory = $false, HelpMessage = "Enable or disable POP3 for the user.")]
        [System.Management.Automation.SwitchParameter]
        $Pop3Access,

        [Parameter(Position = 15, Mandatory = $false, HelpMessage = "Enable or disable SMTP for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SmtpAccess,

        [Parameter(Position = 16, Mandatory = $false, HelpMessage = "Enable or disable Sieve for the user.")]
        [System.Management.Automation.SwitchParameter]
        $SieveAccess,

        [Parameter(Position = 17, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $EasAccess,

        [Parameter(Position = 18, Mandatory = $false, HelpMessage = "Enable or disable Exchange Active Sync.")]
        [System.Management.Automation.SwitchParameter]
        $DavAccess,

        [Parameter(Position = 19, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $AclManageAppPassword,

        [Parameter(Position = 20, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $AclDelimiterAction,

        [Parameter(Position = 21, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $AclResetEasDevice,

        [Parameter(Position = 22, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $AclPushover,

        [Parameter(Position = 23, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAction,

        [Parameter(Position = 24, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineAttachment,

        [Parameter(Position = 25, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotification,

        [Parameter(Position = 26, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $AclQuarantineNotificationCategory,

        [Parameter(Position = 27, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $AclSOGoProfileReset,

        [Parameter(Position = 28, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $AclTemporaryAlias,

        [Parameter(Position = 29, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamPolicy,

        [Parameter(Position = 30, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $AclSpamScore,

        [Parameter(Position = 31, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $AclSyncJob,

        [Parameter(Position = 32, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $AclTlsPolicy,

        [Parameter(Position = 33, Mandatory = $false, HelpMessage = "Allow to reset the user password.")]
        [System.Management.Automation.SwitchParameter]
        $AclPasswordReset
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mailbox/template"
    }

    process {
        # Make an API call for each ID.
        foreach ($IdentityItem in $Identity) {
            # First get the current mailbox template settings to use as base.
            # This is needed because otherwise any option not explicitly specified, will be set to be disabled by the API.
            $CurrentConfig = Get-MailboxTemplate -Raw | Where-Object { $_.id -eq $IdentityItem }

            # Prepare the request body.
            $Body = @{
                items = $IdentityItem.ToSTring()
                attr  = @{
                    # Set current template settings as base values for the update.
                    template                = $CurrentConfig.template
                    quota                   = $CurrentConfig.attributes.quota / 1048576 # to convert bytes into MiB.
                    tags                    = $CurrentConfig.attributes.tags
                    tagged_mail_handler     = $CurrentConfig.attributes.tagged_mail_handler
                    quarantine_notification = $CurrentConfig.attributes.quarantine_notification
                    quarantine_category     = $CurrentConfig.attributes.quarantine_category
                    rl_value                = $CurrentConfig.attributes.rl_value
                    rl_frame                = $CurrentConfig.attributes.rl_frame
                    active                  = $CurrentConfig.attributes.active
                    tls_enforce_in          = $CurrentConfig.attributes.tls_enforce_in
                    tls_enforce_out         = $CurrentConfig.attributes.tls_enforce_out
                    force_pw_update         = $CurrentConfig.attributes.force_pw_update
                    sogo_access             = $CurrentConfig.attributes.sogo_access
                    protocol_access         = [System.Collections.ArrayList]@()
                    acl                     = [System.Collections.ArrayList]@()
                }
            }

            # Prepare arraylists in case needed later.
            $ProtocolAccess = [System.Collections.ArrayList]@()
            $Acl = [System.Collections.ArrayList]@()

            if ($PSBoundParameters.ContainsKey("Name")) {
                $Body.attr.template = $Name.Trim()
            }
            if ($PSBoundParameters.ContainsKey("MailboxQuota")) {
                $Body.attr.quota = $MailboxQuota.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Tag")) {
                $Body.attr.tags = $Tag
            }
            if ($PSBoundParameters.ContainsKey("TaggedMailHandler")) {
                $Body.attr.tagged_mail_handler = $TaggedMailHandler.ToLower()
            }
            if ($PSBoundParameters.ContainsKey("QuaranantineNotification")) {
                $Body.attr.quarantine_notification = $QuaranantineNotification.ToLower()
            }
            if ($PSBoundParameters.ContainsKey("QuaranantineCategory")) {
                $Body.attr.quarantine_category = switch ($QuaranantineCategory) {
                    "Rejected" {
                        "reject"
                        break
                    }
                    "Junk folder" {
                        "add_header"
                        break
                    }
                    default {
                        # "All categories"
                        "all"
                    }
                }
            }
            if ($PSBoundParameters.ContainsKey("RateLimitValue")) {
                $Body.attr.rl_value = $RateLimitValue.ToString()
            }
            if ($PSBoundParameters.ContainsKey("RateLimitFrame")) {
                $Body.attr.rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
            }
            if ($PSBoundParameters.ContainsKey("ActiveState")) {
                $Body.attr.active = "$($ActiveState.value__)"
            }

            if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
                $Body.attr.tls_enforce_in = if ($EnforceTlsIn.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
                $Body.attr.tls_enforce_out = if ($EnforceTlsOut.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("ForcePasswordUpdate")) {
                $Body.attr.force_pw_update = if ($ForcePasswordUpdate.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("SogoAccess")) {
                $Body.attr.sogo_access = if ($SogoAccess.IsPresent) { "1" } else { "0" }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("ImapAccess")) {
                # Parameter was specified.
                if ($ImapAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("imap")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.imap_access) {
                    $null = $ProtocolAccess.Add("imap")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("Pop3Access")) {
                # Parameter was specified.
                if ($Pop3Access.IsPresent) {
                    $null = $ProtocolAccess.Add("pop3")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.pop3_access) {
                    $null = $ProtocolAccess.Add("pop3")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("SmtpAccess")) {
                # Parameter was specified.
                if ($SmtpAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("smtp")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.smtp_access) {
                    $null = $ProtocolAccess.Add("smtp")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("SieveAccess")) {
                # Parameter was specified.
                if ($SieveAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("sieve")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.sieve_access) {
                    $null = $ProtocolAccess.Add("sieve")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("EasAccess")) {
                # Parameter was specified.
                if ($EasAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("eas")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.eas_access) {
                    $null = $ProtocolAccess.Add("eas")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("DavAccess")) {
                # Parameter was specified.
                if ($DavAccess.IsPresent) {
                    $null = $ProtocolAccess.Add("dav")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.dav_access) {
                    $null = $ProtocolAccess.Add("dav")
                }
            }

            # ACL options.

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclManageAppPassword")) {
                # Parameter was specified.
                if ($AclManageAppPassword.IsPresent) {
                    $null = $Acl.Add("app_passwds")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_app_passwds) {
                    $null = $Acl.Add("app_passwds")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclDelimiterAction")) {
                # Parameter was specified.
                if ($AclDelimiterAction.IsPresent) {
                    $null = $Acl.Add("delimiter_action")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_delimiter_action) {
                    $null = $Acl.Add("delimiter_action")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclResetEasDevice")) {
                # Parameter was specified.
                if ($AclResetEasDevice.IsPresent) {
                    $null = $Acl.Add("eas_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_eas_reset) {
                    $null = $Acl.Add("eas_reset")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclPushover")) {
                # Parameter was specified.
                if ($AclPushover.IsPresent) {
                    $null = $Acl.Add("pushover")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_pushover) {
                    $null = $Acl.Add("pushover")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineAction")) {
                # Parameter was specified.
                if ($AclQuarantineAction.IsPresent) {
                    $null = $Acl.Add("quarantine")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine) {
                    $null = $Acl.Add("quarantine")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineAttachment")) {
                # Parameter was specified.
                if ($AclQuarantineAttachment.IsPresent) {
                    $null = $Acl.Add("quarantine_attachments")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_attachments) {
                    $null = $Acl.Add("quarantine_attachments")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineNotification")) {
                # Parameter was specified.
                if ($AclQuarantineNotification.IsPresent) {
                    $null = $Acl.Add("quarantine_notification")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_notification) {
                    $null = $Acl.Add("quarantine_notification")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclQuarantineNotificationCategory")) {
                # Parameter was specified.
                if ($AclQuarantineNotificationCategory.IsPresent) {
                    $null = $Acl.Add("quarantine_category")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_quarantine_category) {
                    $null = $Acl.Add("quarantine_category")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSOGoProfileReset")) {
                # Parameter was specified.
                if ($AclSOGoProfileReset.IsPresent) {
                    $null = $Acl.Add("sogo_profile_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_sogo_profile_reset) {
                    $null = $Acl.Add("sogo_profile_reset")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclTemporaryAlias")) {
                # Parameter was specified.
                if ($AclTemporaryAlias.IsPresent) {
                    $null = $Acl.Add("spam_alias")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_alias) {
                    $null = $Acl.Add("spam_alias")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSpamPolicy")) {
                # Parameter was specified.
                if ($AclSpamPolicy.IsPresent) {
                    $null = $Acl.Add("spam_policy")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_policy) {
                    $null = $Acl.Add("spam_policy")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSpamScore")) {
                # Parameter was specified.
                if ($AclSpamScore.IsPresent) {
                    $null = $Acl.Add("spam_score")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_spam_score) {
                    $null = $Acl.Add("spam_score")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclSyncJob")) {
                # Parameter was specified.
                if ($AclSyncJob.IsPresent) {
                    $null = $Acl.Add("syncjobs")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_syncjobs) {
                    $null = $Acl.Add("syncjobs")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclTlsPolicy")) {
                # Parameter was specified.
                if ($AclSAclTlsPolicyyncJob.IsPresent) {
                    $null = $Acl.Add("tls_policy")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_tls_policy) {
                    $null = $Acl.Add("tls_policy")
                }
            }

            # Set options based on current config or parameter values.
            if ($PSBoundParameters.ContainsKey("AclPasswordReset")) {
                # Parameter was specified.
                if ($AclPasswordReset.IsPresent) {
                    $null = $Acl.Add("pw_reset")
                }
            }
            else {
                # Parameter was not specified. So no change requested and therefore set the value only if it was set before.
                if ($CurrentConfig.Attributes.acl_pw_reset) {
                    $null = $Acl.Add("pw_reset")
                }
            }

            $Body.attr.protocol_access = $ProtocolAccess
            $Body.attr.acl = $Acl

            if ($PSCmdlet.ShouldProcess("mailbox template [$IdentityItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating mailbox template [$IdentityItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-MailboxTlsPolicy {
    <#
    .SYNOPSIS
        Updates the TLS policy for incoming and outgoing connections for one or more mailboxes.

    .DESCRIPTION
        Updates the TLS policy for incoming and outgoing connections for one or more mailboxes.

    .PARAMETER Identity
        The mail address of the mailbox for which to set the TLS policy.

    .PARAMETER EnforceTlsIn
        Enforce TLS for incoming connections.

    .PARAMETER EnforceTlsOut
        Enforce TLS for outgoing connections.

    .EXAMPLE
        Set-MHMailboxTlsPolicy -Identity "user123@example.com" -EnforceTlsIn -EnforceTlsOut

        Enable TLS policy for incoming and outgoing connections for the mailbox of the user "user123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxQuarantineNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the TLS policy.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Enforce TLS for incoming connections for this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsIn,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Enforce TLS for outgoing connections from this mailbox.")]
        [System.Management.Automation.SwitchParameter]
        $EnforceTlsOut
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/tls_policy"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("EnforceTlsIn")) {
            $Body.attr.tls_enforce_in = if ($EnforceTlsIn.IsPresent) {
                Write-MailcowHelperLog -Message "[$LogIdString] Enable enforcing TLS for incoming connections for the mailbox."
                "1"
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Disable enforcing TLS for incoming connections for the mailbox."
                "0"
            }
        }
        if ($PSBoundParameters.ContainsKey("EnforceTlsOut")) {
            $Body.attr.tls_enforce_out = if ($EnforceTlsOut.IsPresent) {
                Write-MailcowHelperLog -Message "[$LogIdString] Enable enforcing TLS for Outgoing connections for the mailbox."
                "1"
            }
            else {
                Write-MailcowHelperLog -Message "[$LogIdString] Disable enforcing TLS for Outgoing connections for the mailbox."
                "0"
            }
        }

        if ($PSCmdlet.ShouldProcess("mailbox TLS policy [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox TLS policy [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailboxUserACL {
    <#
    .SYNOPSIS
        Updates the ACL (Access Control List) for one or more mailboxes.

    .DESCRIPTION
        Updates the ACL (Access Control List) for one or more mailboxes.

        The cmdlet overwrites the entire ACL set for the mailbox. Use with caution!

    .PARAMETER Identity
        The mail address of the mailbox for which ACL settings should be updated.

    .PARAMETER ResetToDefault
        Resets all ACL permissions to their default values.

    .PARAMETER ManageAppPassword
        Allows the user to manage application passwords.

    .PARAMETER DelimiterAction
        Allows the user to manage delimiter actions.

    .PARAMETER ResetEasDevice
        Allows the user to reset EAS devices.

    .PARAMETER Pushover
        Allows the user to manage Pushover settings.

    .PARAMETER QuarantineAction
        Allows the user to perform quarantine actions.

    .PARAMETER QuarantineAttachment
        Allows the user to manage quarantine attachments.

    .PARAMETER QuarantineNotification
        Allows the user to modify quarantine notification settings.

    .PARAMETER QuarantineNotificationCategory
        Allows the user to modify quarantine notification categories.

    .PARAMETER TemporaryAlias
        Allows the user to manage temporary aliases.

    .PARAMETER SpamPolicy
        Allows the user to manage SPAM policy settings.

    .PARAMETER SpamScore
        Allows the user to manage SPAM score settings.

    .PARAMETER TlsPolicy
        Allows the user to manage TLS policy settings.

    .PARAMETER PasswordReset
        Allow to reset mailcow user password.
        Not part of the default ACL.

    .PARAMETER SyncJob
        Allows the user to manage sync jobs.
        Not part of the default ACL.

    .PARAMETER SOGoProfileReset
        Allows the user to reset their SOGo profile.
        Not part of the default ACL.

    .EXAMPLE
        Set-MHMailboxUserACL -Identity "user@example.com" -ResetToDefault

        Resets all ACL permissions for the mailbox to Mailcow defaults.

    .EXAMPLE
        Set-MHMailboxUserACL -Identity "user@example.com" -ManageAppPassword -SpamPolicy -TlsPolicy

        Enables the specified ACL permissions for the mailbox.

    .EXAMPLE
        "one@example.com","two@example.com" | Set-MHMailboxUserACL -ResetToDefault

        Resets ACL permissions for multiple mailboxes using pipeline input.

    .NOTES
        This cmdlet overwrites all existing ACL settings.
        Ensure you understand the implications before applying changes.

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MailboxUserACL.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(ParameterSetName = "IndividualSettings", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which ACL settings should be updated.")]
        [Parameter(ParameterSetName = "DefaultSettings", Position = 0, Mandatory = $true, ValueFromPipeline = $true)]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(ParameterSetName = "DefaultSettings", Position = 1, Mandatory = $true, HelpMessage = "Reset all permissions to default values.")]
        [System.Management.Automation.SwitchParameter]
        $ResetToDefault,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 1, Mandatory = $false, HelpMessage = "Allow to manage app passwords.")]
        [System.Management.Automation.SwitchParameter]
        $ManageAppPassword,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 2, Mandatory = $false, HelpMessage = "Allow Delimiter Action.")]
        [System.Management.Automation.SwitchParameter]
        $DelimiterAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 3, Mandatory = $false, HelpMessage = "Allow to reset EAS device.")]
        [System.Management.Automation.SwitchParameter]
        $ResetEasDevice,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 4, Mandatory = $false, HelpMessage = "Allow Pushover.")]
        [System.Management.Automation.SwitchParameter]
        $Pushover,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 5, Mandatory = $false, HelpMessage = "Allow quarantine action.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineAction,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 6, Mandatory = $false, HelpMessage = "Allow quarantine attachement.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineAttachment,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 7, Mandatory = $false, HelpMessage = "Allow to change quarantine notification.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineNotification,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 8, Mandatory = $false, HelpMessage = "Allow to change quarantine notification category.")]
        [System.Management.Automation.SwitchParameter]
        $QuarantineNotificationCategory,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 9, Mandatory = $false, HelpMessage = "Allow to manage temporary alias.")]
        [System.Management.Automation.SwitchParameter]
        $TemporaryAlias,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 10, Mandatory = $false, HelpMessage = "Allow to manage SPAM policy.")]
        [System.Management.Automation.SwitchParameter]
        $SpamPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 11, Mandatory = $false, HelpMessage = "Allow to manage SPAM score.")]
        [System.Management.Automation.SwitchParameter]
        $SpamScore,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 12, Mandatory = $false, HelpMessage = "Allow to manage TLS policy.")]
        [System.Management.Automation.SwitchParameter]
        $TlsPolicy,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 13, Mandatory = $false, HelpMessage = "Allow to reset mailcow user password.")]
        [System.Management.Automation.SwitchParameter]
        $PasswordReset,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 14, Mandatory = $false, HelpMessage = "Allow to manage sync job.")]
        [System.Management.Automation.SwitchParameter]
        $SyncJob,

        [Parameter(ParameterSetName = "IndividualSettings", Position = 15, Mandatory = $false, HelpMessage = "Allow to reset the SOGo profile.")]
        [System.Management.Automation.SwitchParameter]
        $SOGoProfileReset
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/user-acl"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        Write-MailcowHelperLog -Message "[$LogIdString] Updating quarantine notification setting for mailbox."

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
            attr  = @{
                user_acl = [System.Collections.ArrayList]@()
            }
        }

        # Set the default options or any explicitly defined options.
        if ($ResetToDefault.IsPresent -or $ManageAppPassword.IsPresent) {
            $null = $Body.attr.user_acl.Add("app_passwds")
        }
        if ($ResetToDefault.IsPresent -or $DelimiterAction.IsPresent) {
            $null = $Body.attr.user_acl.Add("delimiter_action")
        }
        if ($ResetToDefault.IsPresent -or $Pushover.IsPresent) {
            $null = $Body.attr.user_acl.Add("pushover")
        }
        if ($ResetToDefault.IsPresent -or $ResetEasDevice.IsPresent) {
            $null = $Body.attr.user_acl.Add("eas_reset")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineAction.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineAttachment.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_attachments")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineNotification.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_notification")
        }
        if ($ResetToDefault.IsPresent -or $QuarantineNotificationCategory.IsPresent) {
            $null = $Body.attr.user_acl.Add("quarantine_category")
        }
        if ($ResetToDefault.IsPresent -or $TemporaryAlias.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_alias")
        }
        if ($ResetToDefault.IsPresent -or $SpamPolicy.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_policy")
        }
        if ($ResetToDefault.IsPresent -or $SpamScore.IsPresent) {
            $null = $Body.attr.user_acl.Add("spam_score")
        }
        if ($ResetToDefault.IsPresent -or $TlsPolicy.IsPresent) {
            $null = $Body.attr.user_acl.Add("tls_policy")
        }

        # Set the non-default options only if specified explicitely.
        if ($PasswordReset.IsPresent) {
            $null = $Body.attr.user_acl.Add("pw_reset")
        }
        if ($SyncJob.IsPresent) {
            $null = $Body.attr.user_acl.Add("syncjobs")
        }
        if ($SOGoProfileReset.IsPresent) {
            $null = $Body.attr.user_acl.Add("sogo_profile_reset")
        }

        Write-MailcowHelperLog -Message "Setting the ACL will overwrite any existing ACL. Know what you do!" -Level "Warning"

        if ($PSCmdlet.ShouldProcess("Mailbox user ACL for [$LogIdString]", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailbox user ACL for [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-MailcowHelperConfig {
    <#
    .SYNOPSIS
        Saves settings to a MailcowHelper config file.

    .DESCRIPTION
        Saves settings to a MailcowHelper config file.
        This allows to re-use previously saved settings like mailcow servername, API key or argument completer configuration.

    .PARAMETER Path
        The full path to a MailcowHelper settings file (a JSON file).

    .EXAMPLE
        Set-MHMailcowHelperConfig

        Saves settings to the default MailcowHelper config file in $env:USERPROFILE\.MailcowHelper.json

    .INPUTS
        Nothing

    .OUTPUTS
        Nothing

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-MailcowHelperConfig.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The full path to a MailcowHelper settings file (a JSON file).")]
        [Alias("FilePath")]
        [System.IO.FileInfo]
        $Path
    )

    # Define a default path if none was specified, depending on the OS.
    if ($null -eq $Path) {
        switch ($PSVersionTable.Platform) {
            "Win32NT" {
                $Path = "$env:USERPROFILE\.MailcowHelper.json"
                break
            }
            "Unix" {
                $Path = "$env:HOME\.MailcowHelper.json"
                break
            }
            default {
                Write-MailcowHelperLog -Message "Operating system not detected." -Level Warning
            }
        }
    }

    # Save current date/time.
    $CurrentDateTime = Get-Date

    # Prepare a default config.
    $DefaultConfig = @{
        MetaData    = @{
            WhenCreated                = $CurrentDateTime
            WhenUpdated                = $CurrentDateTime
            MailcowHelperModuleVersion = $((Get-Module -Name MailcowHelper).Version.ToString())
        }
        SessionData = @{
            ConnectParams           = @{
                Computername         = ""
                ApiVersion           = "v1"
                ApiKey               = ""
                Insecure             = $false
                SkipCertificateCheck = $false
            }
            ArgumentCompleterConfig = @{
                EnableFor = @(
                    "Alias",
                    "AliasDomain",
                    "Domain",
                    "DomainTemplate",
                    "DomainAdmin",
                    "Mailbox",
                    "MailboxTemplate",
                    "Resource"
                )
            }
        }
    }

    # Check if the path exists.
    if (Test-Path -Path $Path) {
        # The file exists, therefore read current config from $Path and just update it.
        $CurrentConfig = Get-MailcowHelperConfig -Path $Path -Passthru
        # Update the modified timestamp.
        if ($CurrentConfig.MetaData) {
            $CurrentConfig.MetaData.WhenUpdated = $CurrentDateTime
        }
    }
    else {
        # Build data from scratch by using the default config.
        $CurrentConfig = $DefaultConfig
    }

    # Update ConnectParams SessionData.
    if ($Script:MailcowHelperSession.ConnectParams) {
        # Save the connection parameters from the session variable.
        $CurrentConfig.SessionData.ConnectParams = $Script:MailcowHelperSession.ConnectParams
        # Convert the ApiKey value to a secure string.
        $CurrentConfig.SessionData.ConnectParams.ApiKey = $Script:MailcowHelperSession.ConnectParams.ApiKey | ConvertTo-SecureString -AsPlainText | ConvertFrom-SecureString
    }

    # Update ArgumentCompleter SessionData.
    if ($Script:MailcowHelperSession.ArgumentCompleterConfig) {
        # Save the connection parameters from the session variable.
        $CurrentConfig.SessionData.ArgumentCompleterConfig = $Script:MailcowHelperSession.ArgumentCompleterConfig
    }

    if ($PSCmdlet.ShouldProcess("MailcowHelper config to file [$($Path.Fullname)].", "Save")) {
        Write-MailcowHelperLog -Message "Saving MailcowHelper config to file [$($Path.Fullname)]." -Level Information

        # Save the config in the file.
        Write-MailcowHelperLog -Message "[$($Path.FullName)] Save config to file." -Level Information
        $CurrentConfig | ConvertTo-Json -Depth 3 | Set-Content -Path $Path
    }
}

function Set-MtaSts {
    <#
    .SYNOPSIS
        Updates the MTS-STS policy for one or more domains.

    .DESCRIPTION
        Updates the MTS-STS policy for one or more domains.
        There can only be one MTA-STS policy per domain.
        Refer to the mailcow documentation for more information.

    .PARAMETER Domain
        The name of the domain for which to update a MTA-STS policy.

    .PARAMETER Version
        The MTA-STS version. Only STSv1 is available.

    .PARAMETER Mode
        The MTA-STS mode to use. Valid options are:
        Enforce, Testing, None

    .PARAMETER MxServer
        The MxServer to use.

    .PARAMETER MaxAge
        Time in seconds that receiving mail servers may cache this policy until refetching.

    .EXAMPLE
        Set-MHMtaSts -Domain "example.com" -Mode Enforce -MxServer 1.2.3.4, 5.6.7.8

        Update the MTA-STS policy for domain "example.com" in enforce mode with two MX servers.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-MtaSts.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the domain for which to add a MTA-STS policy.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [Alias("Domain")]
        [System.String[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The STS version.")]
        [ValidateSet("STSv1")]
        [System.String]
        $Version = "STSv1",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The MTA-STS mode to use.")]
        [ValidateSet("Enforce", "Testing", "None")]
        [System.String]
        $Mode = "Enforce",

        [Parameter(Position = 3, Mandatory = $true, HelpMessage = "The MxServer to use.")]
        [System.String[]]
        $MxServer,

        [Parameter(Position = 4, Mandatory = $true, HelpMessage = "Time in seconds that receiving mail servers may cache this policy until refetching.")]
        [ValidateRange(1, 31536000)]
        [System.Int32]
        $MaxAge = 86400 # 86400 seconds = 1 day
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/mta-sts"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Identity
            attr  = @{
                version = $Version.ToLower()
                mode    = $Mode.ToLower()
                mx      = $MxServer -join ","
                max_age = $MaxAge
            }
        }

        Write-MailcowHelperLog -Message "This function updates a MTA-STS policy. To enable or disable a policy you have to use the mailcow admin UI because it is not possible to do this via the API." -Level Warning

        if ($PSCmdlet.ShouldProcess("domain mta-sts [$($Identity -join ", ")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating domain mta-sts [$($Identity -join ", ")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-OauthClient {
    <#
    .SYNOPSIS
        Updates an OAuth client configuration on the mailcow server.

    .DESCRIPTION
        Updates an OAuth client configuration on the mailcow server.

    .PARAMETER Id
        The id value of a specific OAuth client.

    .PARAMETER RedirectUri
        The redirect URI for the OAuth client.

    .PARAMETER RenewSecret
        Renew client secret.

    .EXAMPLE
        Set-MHOauthClient -Id 12 RenewSecret

        Renews the client secret for OAuth client configuration with id 12.

    .INPUTS
        System.Int32

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-OauthClient.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id value of a specific OAuth client.")]
        [System.Int32]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The redirect URI for new OAuth client.")]
        [System.Uri]
        $RedirectUri,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Renew client secret.")]
        [System.Management.Automation.SwitchParameter]
        $RenewSecret
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/oauth2-client"
    }

    process {
        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = $Id
            attr  = @{
                redirect_uri = $RedirectUri.AbsoluteUri
            }
        }
        if ($PSBoundParameters.ContainsKey("RenewSecret")) {
            if ($RenewSecret.IsPresent) {
                $Body.attr.renew_secret = $true
            }
        }

        if ($PSCmdlet.ShouldProcess("mailcow mail Oauth client [$Id].", "Update")) {
            Write-MailcowHelperLog -Message "Updating Oauth client with id [$Id]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-PasswordNotification {
    <#
    .SYNOPSIS
        Updates the password reset notification settings on the mailcow server.

    .DESCRIPTION
        Updates the password reset notification settings on the mailcow server.

    .PARAMETER FromAddress
        The sender address for password reset notification emails.

    .PARAMETER Subject
        The subject of the password reset notification email.

    .PARAMETER BodyText
        The body of the password reset notification email in plain text format.

    .PARAMETER MustContainLowerUpperCase
        The body of the password reset notification email in plain HTML format.

    .EXAMPLE
        Set-MHPasswordNotification -From "password-reset@example.com" -Subject "Password reset"

        Set the sender address and the subject for password reset notification emails in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-PasswordNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The sender address for password reset notification emails.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $FromAddress,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The subject of the password reset notification email.")]
        [System.String]
        $Subject,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The body of the password reset notification email in plain text format.")]
        [System.String]
        $BodyText,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The body of the password reset notification email in plain HTML format.")]
        [System.String]
        $BodyHtml
    )

    begin {
        $UriPath = "edit/reset-password-notification"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{}
        }
        if ($PSBoundParameters.ContainsKey("FromAddress")) {
            $Body.attr.from = $FromAddress.Address
        }
        if ($PSBoundParameters.ContainsKey("Subject")) {
            $Body.attr.subject = $Subject.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BodyText")) {
            $Body.attr.text = $BodyText
        }
        if ($PSBoundParameters.ContainsKey("BodyHtml")) {
            $Body.attr.html = $BodyHtml
        }

        if ($PSCmdlet.ShouldProcess("password reset notification", "update")) {
            Write-MailcowHelperLog -Message "Updating password reset notification." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-PasswordPolicy {
    <#
    .SYNOPSIS
        Updates the mailcow password policy.

    .DESCRIPTION
        Updates the mailcow password policy.

    .PARAMETER MinimumLength
        The minimum password length.

    .PARAMETER MustContainChar
        If specified, a password must contain at least one character.

    .PARAMETER MustContainSpecialChar
        If specified, a password must contain at least one special character.

    .PARAMETER MustContainLowerUpperCase
        If specified, a password must contain at least one upper and lower case character.

    .PARAMETER MustContainNumber
        If specified, a password must contain at least one number.

    .EXAMPLE
        Set-MHPasswordPolicy

        Returns the mailcow server password policy.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-PasswordPolicy.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The minimum password length.")]
        [ValidateRange(6, 64)]
        [System.Int32]
        $MinimumLength,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainChar,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one special character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainSpecialChar,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one upper and lower case character.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainLowerUpperCase,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If specified, a password must contain at least one number.")]
        [System.Management.Automation.SwitchParameter]
        $MustContainNumber
    )

    begin {
        $UriPath = "edit/passwordpolicy"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{
                length = $MinimumLength.ToString()
            }
        }
        if ($PSBoundParameters.ContainsKey("MustContainChar")) {
            $Body.attr.chars = if ($MustContainChar.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainSpecialChar")) {
            $Body.attr.special_chars = if ($MustContainSpecialChar.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainLowerUpperCase")) {
            $Body.attr.lowerupper = if ($MustContainLowerUpperCase.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("MustContainNumber")) {
            $Body.attr.numbers = if ($MustContainNumber.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("password policy", "Update")) {
            Write-MailcowHelperLog -Message "Updating password policy." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-QuotaNotification {
    <#
    .SYNOPSIS
        Updates the quota notification mail configuration.

    .DESCRIPTION
        Updates the quota notification mail configuration.

    .PARAMETER FromAddress
        The sender address for quota notification emails.

    .PARAMETER Subject
        The subject of the quota notification email.

    .PARAMETER MustContainLowerUpperCase
        The body of the quota notification email in plain HTML format.

    .EXAMPLE
        Set-MHQuotaNotification -From "password-reset@example.com" -Subject "quota warning"

        Set the sender address and the subject for quota notification emails in mailcow.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-QuotaNotification.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The sender address for quota notification emails.")]
        [AllowNull()]
        [System.Net.Mail.MailAddress]
        $FromAddress,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The subject of the quota notification email.")]
        [System.String]
        $Subject,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The body of the quota notification email in plain HTML format.")]
        [System.String]
        $BodyHtml
    )

    begin {
        $UriPath = "edit/quota_notification"
    }

    process {
        # Prepare the request body.
        $Body = @{
            attr = @{}
        }
        if ($PSBoundParameters.ContainsKey("FromAddress")) {
            $Body.attr.sender = $FromAddress.Address
        }
        if ($PSBoundParameters.ContainsKey("Subject")) {
            $Body.attr.subject = $Subject.Trim()
        }
        if ($PSBoundParameters.ContainsKey("BodyHtml")) {
            $Body.attr.html_tmpl = $BodyHtml
        }

        if ($PSCmdlet.ShouldProcess("quota notification", "Update")) {
            Write-MailcowHelperLog -Message "Updating quota notification." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-RateLimit {
    <#
    .SYNOPSIS
        Updates the rate limit for one or more mailboxes or domains.

    .DESCRIPTION
        Updates the rate limit for one or more mailboxes or domains.

    .PARAMETER Mailbox
        The mail address of the mailbox for which to set the rate-limit setting.

    .PARAMETER Domain
        The name of the domain for which to set the rate-limit setting.

    .PARAMETER RateLimitValue
        The rate limite value.

    .PARAMETER RateLimitFrame
        The rate limit unit. Valid values are:
        Second, Minute, Hour, Day

    .EXAMPLE
        Set-MHRateLimit -Mailbox "user123@example.com" -RateLimitValue 10 -RateLimitFrame Minute

        Set the rate-limit for mailbox of user "user123@example.com" to 10 messages per minute.

    .EXAMPLE
        Set-MHRateLimit -Domain "example.com" -RateLimitValue 1000 -RateLimitFrame Hour

        Set the rate-limit for domain "example.com" to 1000 messages per hour.

    .INPUTS
        System.Net.Mail.MailAddress[]
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RateLimit.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(ParameterSetName = "Mailbox", Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to set the rate limit.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Mailbox,

        [Parameter(ParameterSetName = "Domain", Position = 0, Mandatory = $true, HelpMessage = "The name of the domain for which to set the rate limit.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String[]]
        $Domain,

        [Parameter( Position = 1, Mandatory = $true, HelpMessage = "The rate limit value.")]
        # Default mailbox quota accepts max 8 Exabyte.
        # 0 = disable rate limit
        [ValidateRange(0, 9223372036854775807)]
        [System.Int32]
        $RateLimitValue,

        [Parameter( Position = 2, Mandatory = $false, HelpMessage = "The rate limit unit")]
        [ValidateSet("Second", "Minute", "Hour", "Day")]
        [System.String]
        $RateLimitFrame = "Hour"
    )

    begin {
        # Prepare the base Uri path.
        switch ($PSCmdlet.ParameterSetName) {
            "Mailbox" {
                $UriPath = "edit/rl-mbox"
                $MailboxOrDomain = foreach ($MailboxItem in $Mailbox) { $MailboxItem.Address }
            }
            "Domain" {
                $UriPath = "edit/rl-domain"
                $MailboxOrDomain = $Domain
            }
            default {
                # Should not reach this point.
                throw "Invalid parameter set detected. Can not continue."
            }
        }
    }

    process {
        foreach ($MailboxOrDomainItem in $MailboxOrDomain) {
            # Prepare the request body.
            $Body = @{
                items = $MailboxOrDomainItem
                attr  = @{
                    rl_value = $RateLimitValue.ToString()
                    rl_frame = $RateLimitFrame.Substring(0, 1).ToLower()
                }
            }

            if ($PSCmdlet.ShouldProcess("rate limit", "Update")) {
                Write-MailcowHelperLog -Message "Updating rate limit for [$MailboxOrDomain]  to [$RateLimitValue/$RateLimitFrame]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-Resource {
    <#
    .SYNOPSIS
        Updates one or mre mailcow resource accounts.

    .DESCRIPTION
        Updates one or mre mailcow resource accounts.

    .PARAMETER Identity
        The mail address of the resource account to update.

    .PARAMETER Description
        Set the description of the resource account.

    .PARAMETER Type
        Set the resource type.

    .PARAMETER BookingShowBusyWhenBooked
        Show busy when resource is booked.

    .PARAMETER BookingShowAlwaysFree
        Show resource always as free.

    .PARAMETER BookingCustomLimit
        Allow the specified number of bookings only.

    .PARAMETER Enable
        Enable or disable the resource account.

    .EXAMPLE
        Set-MHResource -Identity "resource123@example.com" -Description "Calendar resource"

        Set the description of resource "resource123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "BookingShowBusyWhenBooked", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to update.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [Alias("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The description of the resource account.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The resource type.")]
        [ValidateSet("Location", "Group", "Thing")]
        [System.String]
        $Type,

        [Parameter(ParameterSetName = "BookingShowBusyWhenBooked", Position = 3, Mandatory = $false, HelpMessage = "Show busy when resource is booked.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowBusyWhenBooked,

        [Parameter(ParameterSetName = "BookingShowAlwaysFree", Position = 3, Mandatory = $false, HelpMessage = "Show resource always as free.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowAlwaysFree,

        [Parameter(ParameterSetName = "BookingCustomLimit", Position = 3, Mandatory = $false, HelpMessage = "Allow the specified number of bookings only.")]
        [System.int32]
        $BookingCustomLimit,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the resource account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/resource"
    }

    process {
        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("Description")) {
            $Body.attr.description = $Description.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Type")) {
            $Body.attr.kind = $Type.ToLower()
        }

        # -1 soft limit, show busy when booked
        #  0 always free
        # >0 hard limit, number -eq limit
        # Set it to "show busy when booked" by default. Change later based on the parameter values.

        if ($PSBoundParameters.ContainsKey("BookingShowBusyWhenBooked")) {
            $Body.attr.multiple_bookings = if ($BookingShowBusyWhenBooked.IsPresent) { "-1" }
        }
        if ($PSBoundParameters.ContainsKey("BookingShowAlwaysFree")) {
            $Body.attr.multiple_bookings = if ($BookingShowAlwaysFree.IsPresent) { "0" }
        }
        if ($PSBoundParameters.ContainsKey("BookingCustomLimit")) {
            $Body.attr.multiple_bookings = $BookingCustomLimit
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailcow resource properties for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating resource properties for [$LogIdString]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-RoutingRelayHost {
    <#
    .SYNOPSIS
        Updates one or more relay host configurations.

    .DESCRIPTION
        Updates one or more relay host configurations.

    .PARAMETER Id
        The id of a relay host entry to update.

    .PARAMETER Hostname
        The hostname of the relay host

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the relay host.

    .PARAMETER Password
        The password for the login on the relay host.

    .PARAMETER Enable
        Enable or disable the relay host.

    .EXAMPLE
        Set-MHRoutingRelayHost -Hostname "mail.example.com" -Username "user123@example.com"

        Update relay host with id 7 with hostname "mail.example.com" and username "User123".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RoutingRelayHost.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of a relay host entry to update.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The hostname of the relay host")]
        [System.String[]]
        $Hostname,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The username for the login on the relay host.")]
        [System.String]
        $Username,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The password for the login on the relay host.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "Enable or disable the relay host.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/relayhost"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.hostname = $Hostname.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("Username")) {
            $Body.attr.username = $Username.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("relay host id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating relay host id [$($Id -join ",")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-RoutingTransport {
    <#
    .SYNOPSIS
        Updates one or more transport map configurations.

    .DESCRIPTION
        Updates one or more transport map configurations.
        A transport map entry overrules a sender-dependent transport map (RoutingRelayHost).

    .PARAMETER Id
        The ID number of a specific transport map record.

    .PARAMETER Destination
        The destination domain. Accepts regex.

    .PARAMETER Hostname
        The hostname for the next hop to the destination.

    .PARAMETER Port
        The port to use. Defaults to port 25.

    .PARAMETER Username
        The username for the login on the routing server.

    .PARAMETER Password
        The password for the destination server.

    .PARAMETER IsMxBased
        Enable or disable MX lookup for the transport rule.

    .PARAMETER Enable
        Enable or disable the transport rule.

    .EXAMPLE
        Set-MHRoutingTransport -Domain "example.com" -Hostname "next.hop.to.example.mail" -Username "user123"

        Creates a transport rule for domain "example.com" using "next.hop.to.example.mail" as next hop. The password for the specified user will be requested interactivly on execution.

    .INPUTS
        System.String[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RoutingTransport.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific transport map record.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The destination domain. Accepts regex.")]
        [System.String]
        $Destination,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The hostname for the next hop to the destination.")]
        [System.String]
        $Hostname,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "The port to use. Defaults to port 25.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 25,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "The username for the login on the routing server.")]
        [System.String]
        $Username,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "The password the login on the destination server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Position = 6, Mandatory = $false, HelpMessage = "Enable or disable MX lookup for the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $IsMxBased,

        [Parameter(Position = 7, Mandatory = $false, HelpMessage = "Enable or disable the transport rule.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/transport"
    }

    process {
        foreach ($IdItem in $Id) {
            # Prepare the request body.
            $Body = @{
                items = $IdItem
                attr  = @{}
            }
            if ($PSBoundParameters.ContainsKey("Destination")) {
                $Body.attr.destination = $Destination.Trim().ToLower()
            }
            if ($PSBoundParameters.ContainsKey("Hostname")) {
                $Body.attr.nexthop = $Hostname.Trim().ToLower() + ":" + $Port.ToString()
            }
            if ($PSBoundParameters.ContainsKey("Username")) {
                $Body.attr.username = $Username.Trim()
            }
            if ($PSBoundParameters.ContainsKey("Password")) {
                $Body.attr.password = $Password | ConvertFrom-SecureString -AsPlainText
            }
            if ($PSBoundParameters.ContainsKey("IsMxBased")) {
                $Body.attr.is_mx_based = if ($IsMxBased.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mail transport id [$IdItem].", "Update")) {
                Write-MailcowHelperLog -Message "Updating mail transport id [$IdItem]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $UriPath
                    Method  = "POST"
                    Body    = $Body
                }
                $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

                # Return the result.
                $Result
            }
        }
    }
}

function Set-RspamdSetting {
    <#
    .SYNOPSIS
        Updates one or more Rspamd rules.

    .DESCRIPTION
        Updates one or more Rspamd rules.

    .PARAMETER Id
        The ID number of a specific Rspamd rule.

    .PARAMETER Content
        The script content for the Rspamd rule.

    .PARAMETER Description
        A description for the Rspamd rule.

    .PARAMETER Enable
        Enalbe or disable the Rspamd rule.

    .EXAMPLE
        Set-MHRspamdSetting -Id 12 -Content $(Get-Content -Path .\rule.txt) -Description "My new rule" -Enable:$false

        Updates Rspamd rule with id 12 with content read from ".\rule.txt" file. The rule will be disabled.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-RspamdSetting.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number of a specific Rspamd rule.")]
        [System.Int32[]]
        $Id,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Content,

        [Parameter(Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter(Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/rsetting"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Content")) {
            # Set the rate limit unit, if it was specified.
            $Body.attr.content = $Content
        }
        if ($PSBoundParameters.ContainsKey("Description")) {
            # Set the rate limit unit, if it was specified.
            $Body.attr.desc = $Description
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            # Set the active state in case the "Enable" parameter was specified based on it's value.
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("Rspamd rule id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updateing Rspamd rule id [$($Id -join ",")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-SieveFilter {
    <#
    .SYNOPSIS
        Updates one or more admin defined Sieve filters for a user mailbox.

    .DESCRIPTION
        Updates one or more admin defined Sieve filters for a user mailbox.
        Note that filter definitions updated by this function/API call will only show up in the admin gui (E-Mail / Configuration / Filters).
        A user will not see this filter in SOGo.

    .PARAMETER Id
        The id of the filter script.

    .PARAMETER FilterType
        Either PreFilter or PostFilter.

    .PARAMETER Description
        A description for the new sieve filter script.

    .PARAMETER SieveScriptContent
        The Sieve script.

    .PARAMETER Enable
        Enable or disable the new filter script.

    .EXAMPLE
        Set-MHSieveFilter -Id 12 -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)

        Updates filter script with id 12. The script is loaded from text file ".\PreviouslySavedScript.txt".

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The id of the filter script.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Either PreFilter or PostFilter.")]
        [ValidateSet("PreFilter", "PostFilter")]
        [System.String]
        $FilterType,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "A description for the new sieve filter script.")]
        [System.String]
        $Description,

        [Parameter(Position = 3, Mandatory = $false, Helpmessage = "The Sieve script.")]
        [System.String]
        $SieveScriptContent,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the new filter script.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/filter"
    }

    process {
        $Body = @{
            # Prepare the request body.
            items = $Id
            attr  = @{}
        }
        # Set values based on what was provided by parameters.
        if ($PSBoundParameters.ContainsKey("FilterType")) {
            $Body.attr.filter_type = $FilterType.ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Description")) {
            $Body.attr.script_desc = $Description.Trim()
        }
        if ($PSBoundParameters.ContainsKey("SieveScriptContent")) {
            $Body.attr.script_data = $SieveScriptContent.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailbox sieve filter id [$($Id -join ",")].", "update")) {
            Write-MailcowHelperLog -Message "Updating mailbox sieve filter id [$($Id -join ",")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-SieveGlobalFilter {
    <#
    .SYNOPSIS
        Updates a global Sieve filter script.

    .DESCRIPTION
        Updates a global Sieve filter script.
        Note that mailcow"s Dovecot service will be restartet automatically to apply the new filter.

    .PARAMETER FilterType
        The type of the filter script. Valid values are:
        PreFilter, PostFilter

    .PARAMETER SieveScriptContent
        The Sieve script.

    .EXAMPLE
        Set-MHSieveGlobalFilter -FilterType PreFilter -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)

        Creates a new global prefilter filter script on the mailcow server. The script is loaded from text file ".\PreviouslySavedScript.txt".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveGlobalFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The type of the filter script.")]
        [ValidateSet("PreFilter", "PostFilter")]
        [System.String]
        $FilterType,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The Sieve script conent.")]
        [System.String]
        $SieveScriptContent
    )

    begin {
        # Prepare the base Uri path.
        # The URI path is for action "add", but this action is more like an "edit" because actually the API call and therefore this function
        # updates the existing pre- or post filter scripts. There is only one pre- and one postfilter script. So nothing can be added in that sense.
        $UriPath = "add/global-filter"
    }

    process {
        # Prepare the request body.
        $Body = @{
            filter_type = $FilterType.ToLower()
            script      = $SieveScriptContent.Trim()
        }

        if ($PSCmdlet.ShouldProcess("mailcow global Sieve filter script for [$FilterType]", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailcow global Sieve filter script for [$FilterType]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-SyncJob {
    <#
    .SYNOPSIS
        Updates a sync job configuration on the mailcow server.

    .DESCRIPTION
        Updates a sync job configuration on the mailcow server.

    .PARAMETER JobId
        The ID number for the sync job to delete.

    .PARAMETER Hostname
        The hostname of the remote mail server from where to sync.

    .PARAMETER Port
        The IMAP port number on the remote mail server.

    .PARAMETER Username
        The username for the login on the remote mail server.

    .PARAMETER Password
        The password for the login on the remote mail server.

    .PARAMETER Encryption
        The type of encryption to use for the remote mail server.

    .PARAMETER Interval
        Interval in minutes for checking the remote mailbox.

    .PARAMETER TargetSubfolder
        The name of the folder to where the remote folder should be synced.

    .PARAMETER MaxAge
        Maximum age of messages in days that will be polled from remote (0 = ignore age).

    .PARAMETER MaxBytesPerSecond
        Max. bytes per second (0 = unlimited).

    .PARAMETER TimeoutRemoteHost
        Timeout for connection to remote host (seconds).

    .PARAMETER TimeoutLocalHost
        Timeout for connection to local host (seconds).

    .PARAMETER ExcludeObjectsRegex
        Exclude objects (regex).

    .PARAMETER CustomParameter
        Example: --some-param=xy --other-param=yx

    .PARAMETER DeleteDuplicatesOnDestination
        Delete duplicates on destination (--delete2duplicates). Default is enabled.

    .PARAMETER DeleteFromSourceWhenCompleted
        Delete from source when completed (--delete1). Default is disabled.

    .PARAMETER DeleteMessagesOnDestinationThatAreNotOnSource
        Delete messages on destination that are not on source (--delete2). Default is disabled.

    .PARAMETER AutomapFolders
        Try to automap folders ("Sent items", "Sent" => "Sent" etc.) (--automap). Default is enabled.

    .PARAMETER SkipCrossDuplicates
        Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.

    .PARAMETER SubscribeAll
        Subscribe all folders (--subscribeall). Default is enabled.

    .PARAMETER SimulateSync
        Simulate synchronization (--dry). Default is enabled.

    .PARAMETER Enable
        Enable or disable the sync job.

    .EXAMPLE
        Set-MHSyncJob

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SyncJob.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The ID number for the sync job to update.")]
        [System.Int32]
        $Id,

        [Parameter(Mandatory = $false, HelpMessage = "The hostname of the remote mail server from where to sync.")]
        [System.String]
        $Hostname,

        [Parameter(Mandatory = $false, HelpMessage = "The IMAP port number on the remote mail server.")]
        [ValidateRange(1, 65535)]
        [System.Int32]
        $Port = 993,

        [Parameter(Mandatory = $false, HelpMessage = "The username for the login on the remote mail server.")]
        [System.Net.Mail.MailAddress]
        $Username,

        [Parameter(Mandatory = $false, HelpMessage = "The password for the login on the remote mail server.")]
        [System.Security.SecureString]
        $Password,

        [Parameter(Mandatory = $false, HelpMessage = "The type of encryption to use for the remote mail server.")]
        [ValidateSet("TLS", "SSL", "PLAIN")]
        [System.String]
        $Encryption = "TLS",

        [Parameter(Mandatory = $false, HelpMessage = "Interval in minutes for checking the remote mailbox.")]
        [ValidateRange(0, 43800)]
        [System.Int32]
        $Interval = 20,

        [Parameter(Mandatory = $false, HelpMessage = "The name of the folder to where the remote folder should be synced.")]
        [System.String]
        $TargetSubfolder,

        [Parameter(Mandatory = $false, HelpMessage = "Maximum age of messages in days that will be polled from remote (0 = ignore age).")]
        [ValidateRange(0, 32000)]
        [System.Int32]
        $MaxAge = 0,

        [Parameter(Mandatory = $false, HelpMessage = "Max. bytes per second (0 = unlimited).")]
        [ValidateRange(0, 125000000)]
        [System.Int32]
        $MaxBytesPerSecond = 0,

        [Parameter( Mandatory = $false, HelpMessage = "Timeout for connection to remote host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutRemoteHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Timeout for connection to local host (seconds).")]
        [ValidateRange(1, 32000)]
        [System.Int32]
        $TimeoutLocalHost = 600,

        [Parameter(Mandatory = $false, HelpMessage = "Exclude objects (regex).")]
        [System.String]
        $ExcludeObjectsRegex = "(?i)spam|(?i)junk",

        [Parameter(Mandatory = $false, HelpMessage = "Example: --some-param=xy --other-param=yx")]
        [System.String]
        $CustomParameter,

        [Parameter(Mandatory = $false, Helpmessage = "Delete duplicates on destination (--delete2duplicates). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteDuplicatesOnDestination,

        [Parameter(Mandatory = $false, Helpmessage = "Delete from source when completed (--delete1). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteFromSourceWhenCompleted,

        [Parameter(Mandatory = $false, Helpmessage = "Delete messages on destination that are not on source (--delete2). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $DeleteMessagesOnDestinationThatAreNotOnSource,

        [Parameter(Mandatory = $false, Helpmessage = "Try to automap folders ('Sent items', 'Sent' => 'Sent' etc.) (--automap). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $AutomapFolders,

        [Parameter(Mandatory = $false, Helpmessage = "Skip duplicate messages across folders (first come, first serve) (--skipcrossduplicates). Default is disabled.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCrossDuplicates,

        [Parameter( Mandatory = $false, Helpmessage = "Subscribe all folders (--subscribeall). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SubscribeAll,

        [Parameter(Mandatory = $false, Helpmessage = "Simulate synchronization (--dry). Default is enabled.")]
        [System.Management.Automation.SwitchParameter]
        $SimulateSync,

        [Parameter(Mandatory = $false, HelpMessage = "Enable or disable the sync job.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/syncjob"
    }

    process {
        # Prepare the RequestUri path.
        $RequestUriPath = $UriPath

        # Get the current SyncJob by the specified id value.
        $SyncJobConfiguration = Get-SyncJob -Verbose | Where-Object { $_.id -eq $Id }

        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = $SyncJobConfiguration
        }

        # Set values based on what was provided by parameters.
        if ($PSBoundParameters.ContainsKey("Hostname")) {
            $Body.attr.host1 = $Hostname.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Port")) {
            $Body.attr.port1 = $Port.ToString()
        }
        if ($PSBoundParameters.ContainsKey("Username")) {
            $Body.attr.user1 = $Username.Address
        }
        if ($PSBoundParameters.ContainsKey("Password")) {
            $Body.attr.password1 = $Password | ConvertFrom-SecureString -AsPlainText
        }
        if ($PSBoundParameters.ContainsKey("Encryption")) {
            $Body.attr.enc1 = $Encryption.ToUpper() # must be upper case, because otherwise "access_denied" is returned.
        }
        if ($PSBoundParameters.ContainsKey("Interval")) {
            $Body.attr.mins_interval = $Interval.ToString()
        }
        if ($PSBoundParameters.ContainsKey("MaxAge")) {
            $Body.attr.maxage = $MaxAge.ToString()
        }
        if ($PSBoundParameters.ContainsKey("MaxBytesPerSecond")) {
            $Body.attr.maxbytespersecond = $MaxBytesPerSecond.ToString()
        }
        if ($PSBoundParameters.ContainsKey("TimeoutRemoteHost")) {
            $Body.attr.timeout1 = $TimeoutRemoteHost.ToString()
        }
        if ($PSBoundParameters.ContainsKey("TimeoutLocalHost")) {
            $Body.attr.timeout2 = $TimeoutLocalHost.ToString()
        }
        if ($PSBoundParameters.ContainsKey("ExcludeObjectsRegex")) {
            $Body.attr.exclude = $ExcludeObjectsRegex
        }
        if ($PSBoundParameters.ContainsKey("TargetSubfolder")) {
            $Body.attr.subfolder2 = $TargetSubfolder.Trim()
        }
        if ($PSBoundParameters.ContainsKey("CustomParameter")) {
            $Body.attr.custom_params = $CustomParameter.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteDuplicatesOnDestination")) {
            $Body.attr.delete2duplicates = if ($DeleteDuplicatesOnDestination.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteFromSourceWhenCompleted")) {
            $Body.attr.delete1 = if ($DeleteFromSourceWhenCompleted.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("DeleteMessagesOnDestinationThatAreNotOnSource")) {
            $Body.attr.delete2 = if ($DeleteMessagesOnDestinationThatAreNotOnSource.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("AutomapFolders")) {
            $Body.attr.automap = if ($AutomapFolders.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SkipCrossDuplicates")) {
            $Body.attr.skipcrossduplicates = if ($SkipCrossDuplicates.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SubscribeAll")) {
            $Body.attr.subscribeall = if ($SubscribeAll.IsPresent) { "1" } else { "0" }
        }
        if ($PSBoundParameters.ContainsKey("SimulateSync")) {
            $Body.attr.dry = if ($SimulateSync.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("Update sync job id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating sync job id [$($Id -join ",")]." -Level Information
            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $RequestUriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Set-TlsPolicyMap {
    <#
    .SYNOPSIS
        Updates one or more TLS policy map overrides.

    .DESCRIPTION
        Updates one or more TLS policy map overrides.

    .PARAMETER Id
        The TLS policy map ID to update.

    .PARAMETER Policy
        TLS Policy to use. Valid options are:
        None, May, Encrypt, Dane, Dane-Only, Fingerprint, Verify, Secure

    .PARAMETER Parameter
        Specify additional parameters.
        Example: "protocols=!SSLv2 ciphers=medium exclude=3DES"

    .PARAMETER Enable
        Enable or disable the TLS policy map override.

    .EXAMPLE
        Set-MHTlsPolicyMap -Id 12 -Policy Encrypt

        Changes the TLS policy type to "Encrypt" for the policy with ID 12.

    .INPUTS
        System.Int32[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-TlsPolicyMap.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The TLS policy map ID to update.")]
        [System.Int32[]]
        $Id,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Policy to use.")]
        [ValidateSet("None", "May", "Encrypt", "Dane", "Dane-Only", "Fingerprint", "Verify", "Secure")]
        [System.String]
        $Policy = "Encrypt",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "Specify additional parameters.")]
        [System.String]
        $Parameter,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "Enable or disable the TLS policy map override.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/tls-policy-map"
    }

    process {
        # Prepare the request body.
        $Body = @{
            items = $Id
            attr  = @{}
        }
        if ($PSBoundParameters.ContainsKey("Policy")) {
            $Body.attr.policy = $Policy.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Parameter")) {
            $Body.attr.policy = $Parameter.Trim().ToLower()
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("TLS policy map override id [$($Id -join ",")].", "Update")) {
            Write-MailcowHelperLog -Message "Updating TLS policy map override id [$($Id -join ",")]." -Level Information

            # Execute the API call.
            $InvokeMailcowApiRequestParams = @{
                UriPath = $UriPath
                Method  = "POST"
                Body    = $Body
            }
            $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

            # Return the result.
            $Result
        }
    }
}

function Test-MailboxPushover {
    <#
    .SYNOPSIS
        Test Pushover notification settings for one or more Mailcow mailboxes.

    .DESCRIPTION
        Test Pushover notification settings for one or more Mailcow mailboxes.

    .PARAMETER Identity
        The mailbox (email address) for which Pushover settings should be verified.

    .EXAMPLE
        Test-MHMailboxPushover -Identity "user@example.com"

        Verifies Pushover notification settings for the specified mailbox.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Test-MailboxPushover.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to test PushOver settings.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [Alias("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "edit/pushover-test"
    }

    process {
        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        Write-MailcowHelperLog -Message "Test pushover settings for mailbox [$LogIdString]."

        # Execute the API call.
        $InvokeMailcowApiRequestParams = @{
            UriPath = $UriPath
            Method  = "POST"
            Body    = $Body
        }
        $Result = Invoke-MailcowApiRequest @InvokeMailcowApiRequestParams

        # Return the result.
        $Result
    }
}



$FunctionList = @(
    "Clear-EasCache",
    "Clear-Queue",
    "Connect-Mailcow",
    "Copy-DkimKey",
    "Disable-MailcowHelperArgumentCompleter",
    "Disconnect-Mailcow",
    "Enable-MailcowHelperArgumentCompleter",
    "Get-AddressRewriteBccMap",
    "Get-AddressRewriteRecipientMap",
    "Get-Admin",
    "Get-AliasDomain",
    "Get-AliasMail",
    "Get-AliasTimeLimited",
    "Get-AppPassword",
    "Get-BanList",
    "Get-DkimKey",
    "Get-Domain",
    "Get-DomainAdmin",
    "Get-DomainAntiSpamPolicy",
    "Get-DomainTemplate",
    "Get-Fail2BanConfig",
    "Get-ForwardingHost",
    "Get-IdentityProvider",
    "Get-Log",
    "Get-Mailbox",
    "Get-MailboxLastLogin",
    "Get-MailboxSpamScore",
    "Get-MailboxTemplate",
    "Get-MailcowHelperArgumentCompleterValue",
    "Get-MailcowHelperConfig",
    "Get-OauthClient",
    "Get-PasswordPolicy",
    "Get-Quarantine",
    "Get-Queue",
    "Get-Ratelimit",
    "Get-Resource",
    "Get-RoutingRelayHost",
    "Get-RoutingTransport",
    "Get-RspamdSetting",
    "Get-SieveFilter",
    "Get-SieveGlobalFilter",
    "Get-Status",
    "Get-SyncJob",
    "Get-TlsPolicyMap",
    "Initialize-MailcowHelperSession",
    "Invoke-MailcowApiRequest",
    "New-AddressRewriteBccMap",
    "New-AddressRewriteRecipientMap",
    "New-Admin",
    "New-AliasDomain",
    "New-AliasMail",
    "New-AliasTimeLimited",
    "New-AppPassword",
    "New-DkimKey",
    "New-Domain",
    "New-DomainAdmin",
    "New-DomainAntiSpamPolicy",
    "New-DomainTemplate",
    "New-ForwardingHost",
    "New-Mailbox",
    "New-MailboxTemplate",
    "New-MtaSts",
    "New-OauthClient",
    "New-Resource",
    "New-RoutingRelayHost",
    "New-RoutingTransport",
    "New-RspamdSetting",
    "New-SieveFilter",
    "New-SyncJob",
    "New-TlsPolicyMap",
    "Remove-AddressRewriteBccMap",
    "Remove-AddressRewriteRecipientMap",
    "Remove-Admin",
    "Remove-AliasDomain",
    "Remove-AliasMail",
    "Remove-AliasTimeLimited",
    "Remove-AppPassword",
    "Remove-DkimKey",
    "Remove-Domain",
    "Remove-DomainAdmin",
    "Remove-DomainAntiSpamPolicy",
    "Remove-DomainTag",
    "Remove-DomainTemplate",
    "Remove-ForwardingHost",
    "Remove-Mailbox",
    "Remove-MailboxTag",
    "Remove-MailboxTemplate",
    "Remove-OauthClient",
    "Remove-QuarantineItem",
    "Remove-Queue",
    "Remove-RateLimit",
    "Remove-Resource",
    "Remove-RoutingRelayHost",
    "Remove-RoutingTransport",
    "Remove-RspamdSetting",
    "Remove-SieveFilter",
    "Remove-SyncJob",
    "Remove-TlsPolicyMap",
    "Set-AddressRewriteBccMap",
    "Set-AddressRewriteRecipientMap",
    "Set-Admin",
    "Set-AliasDomain",
    "Set-AliasMail",
    "Set-AliasTimeLimited",
    "Set-AppPassword",
    "Set-Domain",
    "Set-DomainAdmin",
    "Set-DomainAdminAcl",
    "Set-DomainFooter",
    "Set-DomainTemplate",
    "Set-Fail2BanConfig",
    "Set-ForwardingHost",
    "Set-IdPGenericOIDC",
    "Set-IdPKeycloak",
    "Set-IdpLdap",
    "Set-Mailbox",
    "Set-MailboxCustomAttribute",
    "Set-MailboxPushover",
    "Set-MailboxQuarantineNotification",
    "Set-MailboxQuarantineNotificationCategory",
    "Set-MailboxSpamScore",
    "Set-MailboxTaggedMailHandling",
    "Set-MailboxTemplate",
    "Set-MailboxTlsPolicy",
    "Set-MailboxUserACL",
    "Set-MailcowHelperConfig",
    "Set-MtaSts",
    "Set-OauthClient",
    "Set-PasswordNotification",
    "Set-PasswordPolicy",
    "Set-QuotaNotification",
    "Set-RateLimit",
    "Set-Resource",
    "Set-RoutingRelayHost",
    "Set-RoutingTransport",
    "Set-RspamdSetting",
    "Set-SieveFilter",
    "Set-SieveGlobalFilter",
    "Set-SyncJob",
    "Set-TlsPolicyMap",
    "Test-MailboxPushover"
)

foreach ($Function in $FunctionList) {
    Export-ModuleMember -Function $Function -Alias *
}



# Define the types to export with type accelerators.
$ExportableTypes = @(
    [MailcowHelperArgumentCompleterAttribute],
    [MailcowHelperMailboxActiveState]
)


# Get the internal TypeAccelerators class to use its static methods.
$TypeAcceleratorsClass = [psobject].Assembly.GetType(
    'System.Management.Automation.TypeAccelerators'
)
# Ensure none of the types would clobber an existing type accelerator.
# If a type accelerator with the same name exists, throw an exception.
$ExistingTypeAccelerators = $TypeAcceleratorsClass::Get
foreach ($Type in $ExportableTypes) {
    if ($Type.FullName -in $ExistingTypeAccelerators.Keys) {
        $Message = @(
            "Unable to register type accelerator '$($Type.FullName)'"
            'Accelerator already exists.'
        ) -join ' - '

        throw [System.Management.Automation.ErrorRecord]::new(
            [System.InvalidOperationException]::new($Message),
            'TypeAcceleratorAlreadyExists',
            [System.Management.Automation.ErrorCategory]::InvalidOperation,
            $Type.FullName
        )
    }
}
# Add type accelerators for every exportable type.
foreach ($Type in $ExportableTypes) {
    $TypeAcceleratorsClass::Add($Type.FullName, $Type)
}
# Remove type accelerators when the module is removed.
$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    foreach ($Type in $ExportableTypes) {
        $TypeAcceleratorsClass::Remove($Type.FullName)
    }
}.GetNewClosure()



