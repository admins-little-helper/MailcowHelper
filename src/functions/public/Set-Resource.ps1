function Set-Resource {
    <#
    .SYNOPSIS
        Updates one or mre mailcow resource accounts.

    .DESCRIPTION
        Updates one or mre mailcow resource accounts.

    .PARAMETER Identity
        The mail address of the resource account to update.

    .PARAMETER Description
        Set the description of the resource account.

    .PARAMETER Type
        Set the resource type.

    .PARAMETER BookingShowBusyWhenBooked
        Show busy when resource is booked.

    .PARAMETER BookingShowAlwaysFree
        Show resource always as free.

    .PARAMETER BookingCustomLimit
        Allow the specified number of bookings only.

    .PARAMETER Enable
        Enable or disable the resource account.

    .EXAMPLE
        Set-MHResource -Identity "resource123@example.com" -Description "Calendar resource"

        Set the description of resource "resource123@example.com".

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Set-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding(DefaultParameterSetName = "BookingShowBusyWhenBooked", SupportsShouldProcess = $true)]
    param(
        [Parameter(Position = 0, Mandatory = $true, ValueFromPipeline = $true, HelpMessage = "The mail address of the mailbox to update.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [Alias("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "The description of the resource account.")]
        [System.String]
        $Description,

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The resource type.")]
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
        $UriPath = "edit/resource"
    }

    process {
        # Prepare a string that will be used for logging.
        $LogIdString = if ($Identity.Count -gt 1) {
            "$($Identity.Count) mailboxes"
        }
        else {
            foreach ($IdentityItem in $Identity) { $IdentityItem.Address }
        }

        # Prepare the request body.
        $Body = @{
            # Assign all mail addresses to the "items" attribute.
            items = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
            attr  = @{}
        }

        if ($PSBoundParameters.ContainsKey("Description")) {
            $Body.attr.description = $Description.Trim()
        }
        if ($PSBoundParameters.ContainsKey("Type")) {
            $Body.attr.kind = $Type.ToLower()
        }

        # -1 soft limit, show busy when booked
        #  0 always free
        # >0 hard limit, number -eq limit
        # Set it to "show busy when booked" by default. Change later based on the parameter values.

        if ($PSBoundParameters.ContainsKey("BookingShowBusyWhenBooked")) {
            $Body.attr.multiple_bookings = if ($BookingShowBusyWhenBooked.IsPresent) { "-1" }
        }
        if ($PSBoundParameters.ContainsKey("BookingShowAlwaysFree")) {
            $Body.attr.multiple_bookings = if ($BookingShowAlwaysFree.IsPresent) { "0" }
        }
        if ($PSBoundParameters.ContainsKey("BookingCustomLimit")) {
            $Body.attr.multiple_bookings = $BookingCustomLimit
        }
        if ($PSBoundParameters.ContainsKey("Enable")) {
            $Body.attr.active = if ($Enable.IsPresent) { "1" } else { "0" }
        }

        if ($PSCmdlet.ShouldProcess("mailcow resource properties for [$LogIdString].", "Update")) {
            Write-MailcowHelperLog -Message "Updating resource properties for [$LogIdString]." -Level Information

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
