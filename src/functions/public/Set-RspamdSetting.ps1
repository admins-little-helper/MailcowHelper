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
