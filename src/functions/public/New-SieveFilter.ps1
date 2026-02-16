function New-SieveFilter {
    <#
    .SYNOPSIS
        Create a new admin defined Sieve filter for one or more mailboxes.

    .DESCRIPTION
        Create a new admin defined Sieve filter for one or more mailboxes.
        Note that filter definitions created by this function/API call will only show up in the admin GUI (E-Mail / Configuration / Filters).
        A user will not see this filter in SOGo.

    .PARAMETER Identity
        The mail address of the mailbox for which to create a filter script.

    .PARAMETER FilterType
        Either PreFilter or PostFilter.

    .PARAMETER Description
        A description for the new sieve filter script.

    .PARAMETER SieveScriptContent
        The Sieve script.

    .PARAMETER Enable
        Enable or disable the new filter script.

    .EXAMPLE
        New-MHSieveFilter -Identity "user1@example.com" -FilterType PreFilter -Description "A new filter" -SieveScriptContent $(Get-Content -Path .\PreviouslySavedScript.txt)

        Creates a new prefilter filter script for user "user1@example.com". The script is loaded from text file ".\PreviouslySavedScript.txt".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-SieveFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox for which to create a filter script.")]
        [MailcowHelperArgumentCompleter("Mailbox")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $true)]
        [ValidateSet("PreFilter", "PostFilter")]
        [System.String]
        $FilterType,

        [Parameter(Position = 2, Mandatory = $false)]
        [System.String]
        $Description,

        [Parameter(Position = 3, Mandatory = $true)]
        [System.String]
        $SieveScriptContent,

        [Parameter(Position = 4, Mandatory = $false)]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/filter"
    }

    process {
        foreach ($IdentityItem in $Identity) {
            # Prepare the RequestUri path.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($IdentityItem.Address.ToLower())

            # Prepare the request body.
            $Body = @{
                # Set the values that are either mandatory parameters or have a default parameter value.
                username    = $IdentityItem.Address
                filter_type = $FilterType.ToLower()
                script_desc = $Description.Trim()
                script_data = $SieveScriptContent.Trim()

                # Set some default values. These might be overwritten later, depending on what parameters have been specified.
                active      = "1"
            }

            # Set values based on what was provided by parameters.
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }

            if ($PSCmdlet.ShouldProcess("mailbox sieve filter for [$($IdentityItem.Address)].", "Add")) {
                Write-MailcowHelperLog -Message "Adding mailbox sieve filter for [$($IdentityItem.Address)]." -Level Information

                # Execute the API call.
                $InvokeMailcowApiRequestParams = @{
                    UriPath = $RequestUriPath
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
