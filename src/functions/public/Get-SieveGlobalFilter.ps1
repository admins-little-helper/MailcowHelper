function Get-SieveGlobalFilter {
    <#
    .SYNOPSIS
        Return the global Sieve filter script.

    .DESCRIPTION
        Return the global Sieve filter script for the specified type.

    .PARAMETER FilterType
        The type of filter to return. Valid values are:
        All, PreFilter, PostFilter

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHSieveGlobalFilter -All

        Returns the global pre- and post filter Sieve scripts.

    .EXAMPLE
        Get-MHSieveGlobalFilter -PreFilter

        Returns the global prefilter Sieve script.

    .EXAMPLE
        Get-MHSieveGlobalFilter -PostFilter

        Returns the global postfilter Sieve script.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-SieveGlobalFilter.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, HelpMessage = "The type of filter to return.")]
        [ValidateSet("All", "PreFilter", "PostFilter")]
        $FilterType = "All",

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Build full Uri.
    $UriPath = "get/global_filters/"

    # Prepare the RequestUri path.
    $RequestUriPath = $UriPath + $FilterType.ToLower()

    # Execute the API call.
    $Result = Invoke-MailcowApiRequest -UriPath $RequestUriPath

    # Return result.
    if ($Raw.IsPresent) {
        # Return the result in raw format.
        $Result
    }
    else {
        # Prepare the result in a custom format.
        $ConvertedResult = foreach ($Item in $Result) {
            $ConvertedItem = [PSCustomObject]@{
                PreFilter  = $Item.prefilter
                PostFilter = $Item.postfilter
            }
            $ConvertedItem.PSObject.TypeNames.Insert(0, "MHSieveGlobalFilter")
            $ConvertedItem
        }
        # Return the result in custom format.
        $ConvertedResult
    }
}