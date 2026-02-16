function Invoke-MailcowApiRequest {
    <#
    .SYNOPSIS
        Wrapper function for "Invoke-WebRequest" used to call the mailcow API.

    .DESCRIPTION
        Wrapper function for "Invoke-WebRequest" used to call the mailcow API.
        This function simplifies calling the API and is used by functions in this module.

    .PARAMETER UriPath
        Specify the path appended to the base URI.
        The base URI is build from the mailcow server name specified in "Connect-Mailcow", the string "/api/"
        the API version specified in "Connect-Mailcow" and the UriPath specified here.

    .PARAMETER Method
        Specify the HTTP method to use (GET or POST).

    .PARAMETER Body
        The request body.

    .PARAMETER Insecure
        If specified, use http instead of https.

    .PARAMETER Raw
        If specified, return the resulting content of the web request in raw format as JSON string instead of a PSCustomObject.

    .EXAMPLE
        Invoke-MHMailcowApiRequest -UriPath "get/status/version"

        Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version (requires to run "Connect-Mailcow" first).

    .EXAMPLE
        Invoke-MHMailcowApiRequest -UriPath "get/status/version" -Raw

        Makes an API call to "https://your.mailcow.server/api/v1/get/status/version" and returns the mailcow server version as JSON string (requires to run "Connect-Mailcow" first).

    .INPUTS
        Nothing

    .OUTPUTS
        PSCustomObject,
        System.String

    .NOTES
        Author:     Dieter Koch
        Email:      diko@admins-little-helper.de

    .LINK
        https://github.com/admins-little-helper/MailcowHelper/blob/main/docs/help/Invoke-MailcowApiRequest.md
    #>

    [OutputType([PSCustomObject], [System.String])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "Specify the path appended to the base URI.")]
        [System.String]
        $UriPath,

        [Parameter(Position = 1, Mandatory = $false, HelpMessage = "Specify the HTTP method to use (GET or POST).")]
        [ValidateSet("GET", "POST")]
        [System.String]
        $Method = "GET",

        [Parameter(Position = 2, Mandatory = $false, HelpMessage = "The request body.")]
        [System.Object]
        $Body,

        [Parameter(Position = 3, Mandatory = $false, HelpMessage = "If specified, use http instead of https.")]
        [System.Management.Automation.SwitchParameter]
        $Insecure,

        [Parameter(Position = 4, Mandatory = $false, HelpMessage = "If specified, ignore certificate.")]
        [System.Management.Automation.SwitchParameter]
        $SkipCertificateCheck,

        [Parameter(Position = 5, Mandatory = $false, HelpMessage = "If specified, return the raw content data (JSON as System.String) instead of a PSCustomObject.")]
        [System.Management.Automation.SwitchParameter]
        $Raw
    )

    # Check if the MailcowHelperSession variable already has information stored that is required to connect.
    if ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.Computername)) {
        Write-MailcowHelperLog -Message "No computername specified. Run 'Connect-Mailcow' and specify a computer name to connect to." -Level Error
    }
    elseif ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiVersion)) {
        Write-MailcowHelperLog -Message "No API version specified. Run 'Connect-Mailcow' and specify a valid API version." -Level Error
    }
    elseif ([System.String]::IsNullOrEmpty($Script:MailcowHelperSession.ConnectParams.ApiKey)) {
        Write-MailcowHelperLog -Message "No API key specified. Run 'Connect-Mailcow' and specify an API key." -Level Error
    }
    else {
        if ($Insecure.IsPresent -or $Script:MailcowHelperSession.ConnectParams.Insecure) {
            # Use http and show a warning about the Insecure connection.
            $Protocol = "http"
        }
        else {
            # By default use https.
            $Protocol = "https"
        }

        # Build full URI to request.
        $Uri = "$($Protocol)://$($Script:MailcowHelperSession.ConnectParams.Computername)/api/$($Script:MailcowHelperSession.ConnectParams.ApiVersion)/$($UriPath)"
        Write-MailcowHelperLog -Message "Requesting URI [$Uri]."

        # Prepare parameters for the WebRequest.
        $InvokeWebRequestParams = @{
            Uri                  = $Uri
            Method               = $Method
            ContentType          = "application/json"
            Headers              = @{
                "Content-type" = "application/json; charset=utf-8"
                "X-Api-Key"    = $Script:MailcowHelperSession.ConnectParams.ApiKey
            }
            SkipCertificateCheck = $($SkipCertificateCheck.IsPresent -or $Script:MailcowHelperSession.ConnectParams.SkipCertificateCheck)
            ErrorAction          = "Stop"
        }
        if ($null -ne $Body) {
            # Append body as JSON string.
            $InvokeWebRequestParams.Body = $Body | ConvertTo-Json -Depth 5
        }

        # Execute the web request.
        $Result = Invoke-WebRequest @InvokeWebRequestParams

        # Check result.
        if ($null -ne $Result) {
            switch ($Result.StatusCode) {
                200 {
                    if ([System.String]::IsNullOrEmpty($Result.Content)) {
                        Write-MailcowHelperLog -Message "Connection successful, but not authorized." -Level Warning
                    }
                    else {
                        Write-MailcowHelperLog -Message "Connection successful."

                        if ($Raw.IsPresent) {
                            # Return the content received as it is.
                            $Result.Content
                        }
                        else {
                            if ($Result.Content -eq "{}") {
                                # Received an empty JSON object. We don't want to return an empty object.
                                Write-MailcowHelperLog -Message "Received empty result."
                            }
                            else {
                                # Convert the received JSON object ot a PSCustomObject and return it.
                                $Result.Content | ConvertFrom-Json
                            }
                        }
                    }
                    break
                }
                401 {
                    Write-MailcowHelperLog -Message "Access denied / Not authorzied!" -Level Warning
                    break
                }
                default {
                    # tbd
                    break
                }
            }
        }
        else {
            Write-MailcowHelperLog -Message "Error connecting to mailcow server [$Computername]!" -Level Warning
        }
    }
}
