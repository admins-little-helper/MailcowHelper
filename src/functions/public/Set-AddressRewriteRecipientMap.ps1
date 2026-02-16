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
