# MailcowHelper

## About

This is an unofficial PowerShell module allowing to manage mailcow by using the mailcow REST API.

## Disclaimer

This PowerShell module is an independent project and is not affiliated with, endorsed by, or sponsored by mailcow or it's owners. All product names, trademarks, and registered trademarks are the property of their respective owners.

The code is provided "as-is". Use on your own risk.

## Documentation

### PreRequisits

- PowerShell 7.5.4 or later
  - Earlier versions might work, but have not been tested.
- A mailcow server instance.
- An API key for your mailcow server instance with at least read access.

### How to install

```PowerShell
Install-Module -Name MailcowHelper
```

### How to use

```PowerShell
Import-Module -Name MailcowHelper

Connect-MHMailcow -ComputerName mail.example.com -ApiKey ABCDEF-GHIJKL-MNOPQR-STUVWX-YZ1234
```

Then for example to get a list of domains configured on your mailcow server, run this:

```PowerShell
Get-MHDomain
```

Which will return something like this:

```PowerShell

DomainName    DomainHName   Description MaxNumMboxes MaxNumAliases MboxCount AliasCount Relayhost Active WhenCreated         WhenModified
----------    -----------   ----------- ------------ ------------- --------- ---------- --------- ------ -----------         ------------
example.com   example.com   Example              100           400        32          7             True 15.02.2026 22:09:35 15.02.2026 22:32:20
example2.com  example2.com  Example               50           400         7          2             True 15.02.2026 22:28:05

```

Once connected, you can save the connetion parameters and the [argument completer status](#tab-completion--custom-argument-completer) in a json file and re-use it later.  
Just run ```Set-MHMailcowHelperConfig```. By default the config will be saved in ```$env:USERPROFILE\.MailcowHelper.json```. Using the ```-Path``` parameter you can save it anywhere else.

```PowerShell
# Save the config in the default path:
Set-MHMailcowHelperConfig

# Save the config in a custom path:
Set-MHMailcowHelperConfig -Path "C:\Admin\MyMailcowConfig.json"
```

**Important**  
The API key is also stored in the file as secure string. This means: it can only be restored under the same useraccount on the same machine.

After you have saved your connection paramaters, you can re-use it like this:

```PowerShell
# Connect using a previously saved config in the default path $env:USERPROFILE\.MailcowHelper.json
Connect-MHMailcow -LoadConfig
```

Or like this if you want to specify the filepath

```PowerShell
# Connect using a previously saved config from a custom filepath.
Connect-MHMailcow -LoadConfig -Path "C:\Admin\MyMailcowConfig.json"
```

### Additional information

- [Release notes](ReleaseNotes.md)
- [Documentation about the module and for each function](./docs/help//MailcowHelper.md)

### Tab completion / Custom Argument Completer

The module implements a custom ArgumentCompleter class, which adds support for tab-completion for input parameters values like mailboxes/mail-addresses or domain names.
Tab-completion works for the following parameter value types:
- Alias
- AliasDomain
- Domain
- DomainAdmin
- DomainTemplate
- Mailbox
- MailboxTemplate
- Resource

Here's an example of how this works:

![tab-completion-example](./docs/images/tab_completion_example_1.gif)

Please note: The values for the parameter types listed above are loaded automatically every time when executing ```Connect-MHMailcow```.
It is possible to disable argument completion for all or for specific types. Just use ```Disable-MHMailcowHelperArgumentCompleter```, respectively ```Enable-MHMailcowHelperArgumentCompleter``` to enable it again.

### Module Prefix

The module has set the default command prefix "MH" (MailcowHelper). So for example to start a connection to a mailcow server, use ```Connect-MHMailcow```. However, the function's name in the source code is just ```Connect-Mailcow```.
You can use any other prefix you like by specifying it when importing the module like this:

```PowerShell
Import-Module -Name MailcowHelper -Prefix "MooHoo"

Connect-MooHooMailcow -ComputerName mail.example.com -ApiKey ABCDEF-GHIJKL-MNOPQR-STUVWX-YZ1234
```
