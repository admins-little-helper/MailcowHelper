function Set-SieveGlobalFilter {
    <#
    .SYNOPSIS
        Updates a global Sieve filter script.

    .DESCRIPTION
        Updates a global Sieve filter script.
        Note that mailcow"s Dovecot service will be restartet automatically to apply the new filter.

    .PARAMETER FilterType
        The type of the filter script. Valid values are:
        PreFilter, PostFilter

    .PARAMETER SieveScriptContent
        The Sieve script.

    .EXAMPLE
        Set-MHSieveGlobalFilter -FilterType PreFilter -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)

        Creates a new global prefilter filter script on the mailcow server. The script is loaded from text file ".\PreviouslySavedScript.txt".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-SieveGlobalFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true, ConfirmImpact = "High")]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The type of the filter script.")]
        [ValidateSet("PreFilter", "PostFilter")]
        [System.String]
        $FilterType,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The Sieve script conent.")]
        [System.String]
        $SieveScriptContent
    )

    begin {
        # Prepare the base Uri path.
        # The URI path is for action "add", but this action is more like an "edit" because actually the API call and therefore this function
        # updates the existing pre- or post filter scripts. There is only one pre- and one postfilter script. So nothing can be added in that sense.
        $UriPath = "add/global-filter"
    }

    process {
        # Prepare the request body.
        $Body = @{
            filter_type = $FilterType.ToLower()
            script      = $SieveScriptContent.Trim()
        }

        if ($PSCmdlet.ShouldProcess("mailcow global Sieve filter script for [$FilterType]", "Update")) {
            Write-MailcowHelperLog -Message "Updating mailcow global Sieve filter script for [$FilterType]." -Level Information

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
