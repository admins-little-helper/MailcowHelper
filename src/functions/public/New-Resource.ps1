function New-Resource {
    <#
    .SYNOPSIS
        Adds one or more resource accounts on a mailcow server.

    .DESCRIPTION
        Adds one or more resource accounts on a mailcow server.

    .PARAMETER Name
        The name of the new resource account. Will be used as the user part for the mail address.

    .PARAMETER Domain
        The domain in which the resource account should be created.

    .PARAMETER Type
        The resource type.

    .PARAMETER BookingShowBusyWhenBooked
        Show busy when resource is booked.

    .PARAMETER BookingShowAlwaysFree
        Show resource always as free.

    .PARAMETER BookingCustomLimit
        Allow the specified number of bookings only.

    .PARAMETER Enable
        Enable or disable the resource account.

    .EXAMPLE
        New-MHResource

        Returns all resource accounts on a mailcow server.

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/New-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "BookingShowBusyWhenBooked", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The name of the new resource account. Will be used as the user part for the mail address.")]
        [System.String[]]
        $Name,

        [Parameter(Position = 1, Mandatory = $true, HelpMessage = "The domain in which the resource account should be created.")]
        [MailcowHelperArgumentCompleter("Domain")]
        [System.String]
        $Domain,

        [Parameter(Position = 2, Mandatory = $true, HelpMessage = "The resource type.")]
        [ValidateSet("Location", "Group", "Thing")]
        [System.String]
        $Type,

        [Parameter(ParameterSetName = "BookingShowBusyWhenBooked", Position = 3, Mandatory = $false, HelpMessage = "Show busy when resource is booked.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowBusyWhenBooked,

        [Parameter(ParameterSetName = "BookingShowAlwaysFree", Position = 3, Mandatory = $false, HelpMessage = "Show resource always as free.")]
        [System.Management.Automation.SwitchParameter]
        $BookingShowAlwaysFree,

        [Parameter(ParameterSetName = "BookingCustomLimit", Position = 3, Mandatory = $false, HelpMessage = "Allow the specified number of bookings only.")]
        [System.int32]
        $BookingCustomLimit,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "Enable or disable the resource account.")]
        [System.Management.Automation.SwitchParameter]
        $Enable
    )

    begin {
        # Prepare the base Uri path.
        $UriPath = "add/resource"
    }

    process {
        foreach ($NameItem in $Name) {
            # Prepare the request body.
            $Body = @{
                description       = $Name.Trim()
                domain            = $Domain
                kind              = $Type.ToLower()
                active            = "1"

                # -1 soft limit, show busy when booked
                #  0 always free
                # >0 hard limit, number -eq limit
                # Set it to "show busy when booked" by default. Change later based on the parameter values.
                multiple_bookings = "-1"
            }
            if ($PSBoundParameters.ContainsKey("Enable")) {
                $Body.active = if ($Enable.IsPresent) { "1" } else { "0" }
            }
            if ($PSBoundParameters.ContainsKey("BookingShowBusyWhenBooked")) {
                $Body.multiple_bookings = if ($BookingShowBusyWhenBooked.IsPresent) { "-1" }
            }
            if ($PSBoundParameters.ContainsKey("BookingShowAlwaysFree")) {
                $Body.multiple_bookings = if ($BookingShowAlwaysFree.IsPresent) { "0" }
            }
            if ($PSBoundParameters.ContainsKey("BookingCustomLimit")) {
                $Body.multiple_bookings = $BookingCustomLimit
            }

            if ($PSCmdlet.ShouldProcess("resource [$NameItem].", "Add")) {
                Write-MailcowHelperLog -Message "Adding resource [$NameItem]." -Level Information

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
