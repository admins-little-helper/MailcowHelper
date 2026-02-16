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
