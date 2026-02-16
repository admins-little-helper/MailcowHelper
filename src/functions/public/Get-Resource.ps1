function Get-Resource {
    <#
    .SYNOPSIS
        Return information about one or more resource accounts.

    .DESCRIPTION
        Return information about one or more resource accounts.

    .PARAMETER Identity
        The mail address of the resource for which to get information.
        If omitted, all resources are returned.

    .PARAMETER All
        If specified, get information for all resources.

    .PARAMETER Raw
        Return the result in raw format as returned by Invoke-WebRequest.

    .EXAMPLE
        Get-MHResource -Identity "resourceABC@example.com"

        Returns information for resource with mail address "resourceABC@example.com".

    .EXAMPLE
        Get-MHResource

        Returns information for all resource accounts on a mailcow server.

    .INPUTS
        System.Net.Mail.MailAddress[]

    .OUTPUTS
        PSCustomObject

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Get-Resource.md
    #>

    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $false, ValueFromPipeline = $true, HelpMessage = "The mail address of the resource for which to get information.")]
        [MailcowHelperArgumentCompleter("Resource")]
        [Alias("Resource")]
        [System.Net.Mail.MailAddress[]]
        $Identity,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Return the result in raw format as returned by Invoke-WebRequest.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    begin {
        # Build full Uri.
        $UriPath = "get/resource/"

        if ([System.String]::IsNullOrEmpty($Identity)) {
            # In case no specific mailbox name/mail address was given, use "All".
            $ResourceIdentity = "All"
        }
        else {
            # Set the requsted identity to all mail addresses (String value) specified by parameter "Identity".
            $ResourceIdentity = foreach ($IdentityItem in $Identity) {
                $IdentityItem.Address
            }
        }
    }

    process {
        foreach ($ResourceIdentityItem in $ResourceIdentity) {
            # Build full Uri.
            $RequestUriPath = $UriPath + [System.Web.HttpUtility]::UrlEncode($ResourceIdentityItem.ToLower())

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
                    $BookingLimit = $null
                    switch ($Item.multiple_bookings) {
                        -1 {
                            $MultipleBookings = "ShowBusyWhenBooked"
                            break
                        }
                        0 {
                            $MultipleBookings = "ShowAlwaysFree"
                            break
                        }
                        { $_ -ge 1 } {
                            $MultipleBookings = "HardLimit"
                            $BookingLimit = $Item.multiple_bookings
                            break
                        }
                        default {
                            # Unknown/unsupported value.
                        }
                    }

                    $ConvertedItem = [PSCustomObject]@{
                        Name             = $Item.name
                        ResourceType     = $Item.kind
                        MultipleBookings = $MultipleBookings
                        BookingLimit     = $BookingLimit
                        Active           = [System.Boolean][System.Int32]$Item.active
                        ActiveInt        = [System.Boolean][System.Int32]$Item.active_int
                        Description      = $Item.description
                        Domain           = $Item.domain
                        LocalPart        = $Item.local_part
                    }
                    $ConvertedItem.PSObject.TypeNames.Insert(0, "MHResource")
                    $ConvertedItem
                }
                # Return the result in custom format.
                $ConvertedResult
            }
        }
    }
}
