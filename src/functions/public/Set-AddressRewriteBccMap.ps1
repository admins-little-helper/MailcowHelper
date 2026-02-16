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
