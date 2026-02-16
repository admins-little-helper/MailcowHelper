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
