# Author Prasad
# Import Azure Modules
Import-Module Az
Import-Module AzureAD

# Connect to Azure if not already connected
if (!(Get-AzContext)) {
    Connect-AzAccount
}

if (!(Get-AzureADSignedInUser)) {
    Connect-AzureAD
}

# Initialize arrays to store data from all subscriptions
$RBACAssignmentsAll = @()
$PrivilegedRoleAssignmentsAll = @()
$PIMEligibleAssignmentsAll = @()

# Get all Azure subscriptions
$subscriptions = Get-AzSubscription

# Loop through each subscription to gather RBAC and PIM information
foreach ($subscription in $subscriptions) {
    # Set context to the current subscription
    Set-AzContext -SubscriptionId $subscription.Id

    # Retrieve RBAC Role Assignments for the current subscription
    $RBACAssignments = Get-AzRoleAssignment | ForEach-Object {
        [PSCustomObject]@{
            Subscription   = $subscription.Name
            PrincipalName  = $_.SignInName
            RoleName       = $_.RoleDefinitionName
            PrincipalType  = $_.ObjectType
            Scope          = $_.Scope
        }
    }
    $RBACAssignmentsAll += $RBACAssignments

    # Retrieve Privileged Role Assignments from Azure AD (Directory Roles)
    $PrivilegedRoleAssignments = Get-AzureADDirectoryRole | ForEach-Object {
        $role = $_
        Get-AzureADDirectoryRoleMember -ObjectId $role.ObjectId | ForEach-Object {
            [PSCustomObject]@{
                Subscription = $subscription.Name
                RoleName     = $role.DisplayName
                MemberName   = $_.DisplayName
                MemberEmail  = $_.UserPrincipalName
                MemberType   = $_.ObjectType
            }
        }
    }
    $PrivilegedRoleAssignmentsAll += $PrivilegedRoleAssignments

    # Retrieve PIM (Privileged Identity Management) information for eligible users
    $PIMEligibleAssignments = Get-AzPrivilegedRoleAssignment | Where-Object { $_.EligibilityType -eq 'Eligible' } | ForEach-Object {
        [PSCustomObject]@{
            Subscription   = $subscription.Name
            RoleName       = $_.RoleDefinitionName
            PrincipalName  = $_.PrincipalName
            AssignmentType = $_.EligibilityType
            Scope          = $_.Scope
        }
    }
    $PIMEligibleAssignmentsAll += $PIMEligibleAssignments
}

# Export to CSV files
$RBACAssignmentsAll | Export-Csv -Path "AllSubscriptions_RBACAssignments.csv" -NoTypeInformation -Encoding UTF8
$PrivilegedRoleAssignmentsAll | Export-Csv -Path "AllSubscriptions_PrivilegedRoleAssignments.csv" -NoTypeInformation -Encoding UTF8
$PIMEligibleAssignmentsAll | Export-Csv -Path "AllSubscriptions_PIMEligibleAssignments.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Export completed. CSV files saved as AllSubscriptions_RBACAssignments.csv, AllSubscriptions_PrivilegedRoleAssignments.csv, and AllSubscriptions_PIMEligibleAssignments.csv"
