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
