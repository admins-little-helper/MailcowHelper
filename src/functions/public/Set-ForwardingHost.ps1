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
