function Test-CyberAwareAPI {
    if ($null -eq $ENV:PARTNER_API_KEY) {
        throw 'PARTNER_API_KEY is required in .env'
    }
    if ($null -eq $ENV:API_BASE_URL) {
        throw 'API_BASE_URL is required in .env'
    }
}

#This function makes a GET request to the /get-clients endpoint to retrieve a list of clients and client information.
function Get-CyberAwareClients {
    param (
        [string]$ApiBaseUrl = $ENV:API_BASE_URL,
        [string]$PartnerApiKey = $ENV:PARTNER_API_KEY
    )

    $url = "$ApiBaseUrl/$PartnerApiKey/get-clients"
    $headers = @{
    'accept' = 'application/json';
    }

    try {
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method 'GET'

        $ClientsData = @{}
        foreach ($client in $response.clients) {
            $ClientData = [PSCustomObject]@{
                id = $client.id
                client = $client.name
                pro = $client.pro
                lite = $client.lite
                free = $client.free
                created_at = $client.created_at
                referral = $client.referral
                users = $client.users
            }
            $ClientsData += $ClientData
        }
        return $ClientsData
    }
    catch {
        throw "Failed to retrieve clients: $_"
    }
}

<#
    There's no API for this, so we'll just return a static list of CyberAware services. The list includes the `Free`, `Lite`, and `Pro` service tiers.
        # https://kb.cyberaware.com/docs/cyber-aware-businessfree-acquisition-of-new-clients
        # https://kb.cyberaware.com/docs/cyber-aware-lite
        # https://kb.cyberaware.com/docs/cyber-aware-pro
#>
function Get-CyberAwareServices {
    Process {
        $Services = [System.Collections.Generic.List[Object]]::new()
        $ServicesList = @(
            @{
                Name = 'Free'
                Description = 'Basic resources including posters, templates, and a Cyber Risk Dashboard.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            },
            @{
                Name = 'Lite'
                Description = 'Includes Cyber Health Checks, Dashboards, Posters, and Training.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            },
            @{
                Name = 'Pro'
                Description = 'Comprehensive services with simulations, templates, and automated training.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            }
        )
        $Services.AddRange($ServicesList)
        return $Services # [{Name: "service-name", Description: "service-description", Category: ServiceCategoryEnum, Subcategory: ServiceSubCategoryEnum}]
    }
}


# This function sends a GET request to the /get-usage endpoint of the CyberAware API to fetch usage data for clients associated with the partner

function Get-CyberAwareUsage {
    param(
        [string]$ApiBaseUrl = $ENV:API_BASE_URL,
        [string]$PartnerApiKey = $ENV:PARTNER_API_KEY
    )

    $url = "$ApiBaseUrl/$PartnerApiKey/get-usage"
    $headers = @{
        'accept' = 'application/json'
    }

    try {
        # make a GET request to the /get-usage endpoint
        $response = Invoke-RestMethod -Uri $url -Headers $headers -Method 'GET'

        $ClientUsage = @{}

        # this data maps closer to the 'usecure' template
        foreach ($usage in $response.client_usage) {
            $ClientUsageDetail = [PSCustomObject]@{
                ClientID = $usage.client_id
                Type  = $usage.type
                Learners = $usage.learners
                MaxLearners = $usage.max_learners
            }

            $ClientsUsage += $ClientUsageDetail
        }

        return $ClientsUsage
    }
    catch {
        throw "Failed to retrieve usage data: $_"
    }
}

