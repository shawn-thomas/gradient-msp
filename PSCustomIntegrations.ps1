function Test-CyberAwareAPI {
    if ($null -eq $ENV:API_KEY) {
        throw 'API_KEY is required in .env'
    }
    if ($null -eq $ENV:API_BASE_URL) {
        throw 'API_URL is required in .env'
    }
}

# function Invoke-CyberAwareAPI {
#     param(
#         [string]$query
#     )
#     Begin {

#     }
#     Process {
#         $RequestHeaders = @{
#             'x-api-key' = $ENV:API_KEY
#             'Content-Type' = 'application/json'
#         }
#         $RequestURI = $ENV:API_BASE_URL
#         $RequestBodyJSON = @{
#             query = $query
#         } | ConvertTo-Json
#         $response = Invoke-WebRequest -Uri $RequestURI -Headers $RequestHeaders -Body $RequestBodyJSON -Method 'POST' | ConvertFrom-Json
#         return $response
#     }
# }

# function Get-CyberAwareClients {
#     #
#     param()
#     Process {
#         $Accounts = @{}
#         $Query = 'query { company { id, externalId, clients { name, id } } }'
#         $APIResponse = Invoke-usecureAPI -query $Query
#         $AccountObjects = $APIResponse.data.company.clients
#         foreach ($AccountObject in $AccountObjects) {
#             $Account = @{
#                 id = $AccountObject.id
#                 name = $AccountObject.name
#             }
#             $Accounts[$AccountObject.id] = $Account
#         }
#         return $Accounts
#     }
# }

function Get-CyberAwareServices {
    Process {
        # There's no API for this, so we'll just return a static list.
        # https://kb.cyberaware.com/docs/cyber-aware-businessfree-acquisition-of-new-clients
        # https://kb.cyberaware.com/docs/cyber-aware-lite
        # https://kb.cyberaware.com/docs/cyber-aware-pro
        $Services = [System.Collections.Generic.List[Object]]::new()
        $ServicesList = @(
            @{
                Name = 'Free'
                Description = 'Free resources, including 4 branded posters, basic policy templates, security guides, a Cyber Health Check, and a Cyber Risk Dashboard.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            },
            @{
                Name = 'Lite'
                Description = 'Lite offers optional Cyber Health Checks, Dashboards, and Toolkits, plus Security Awareness Posters, Training, and Reporting.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            },
            @{
                Name = 'Pro'
                Description = 'Pro offers optional Cyber Health Checks, Dashboards, and Toolkits, plus Security Awareness and Phishing Simulations, Templates, Automated Training, and Reporting.'
                Category = 'security'
                Subcategory = 'privacy and security awareness training'
            }
        )
        $Services.AddRange($ServicesList)
        return $Services # [{Name: "service-name", Description: "service-description", Category: ServiceCategoryEnum, Subcategory: ServiceSubCategoryEnum}]
    }
}

# Function Get-CyberAwareUsage {
#     param(
#         [string]$companyId
#     )
#     Process {
#         $Query = "query { company(companyId: `"$companyId`") { plan { name, learnerCount, learnerLimit } } }"
#         $APIResponse = Invoke-usecureAPI -query $Query
#         $AccountUsage += $APIResponse.data.company.plan
#         return $AccountUsage #Format is unique for each vendor, and how it is implemented in PSSyncUsage.ps1
#     }
# }