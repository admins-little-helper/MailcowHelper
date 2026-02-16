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
