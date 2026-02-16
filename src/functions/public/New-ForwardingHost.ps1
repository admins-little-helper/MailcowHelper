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
