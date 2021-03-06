$PasswordProfile = New-Object -TypeName Microsoft.Open.AzureAD.Model.PasswordProfile
$PasswordProfile.Password = "Pa55w.rd12345"
$PasswordProfile.ForceChangePasswordNextLogin = "False"
$tenant = (Get-AzureADTenantDetail).verifiedDomains.name
# $UPN = "admin@" + $tenant
# $currentuser = (get-azureaduser).userprincipalname.tostring()

# if ($currentuser.startswith("admin@", 1)) { New-AzureADUser -DisplayName "Admin" -PasswordProfile $PasswordProfile -UserPrincipalName $UPN -AccountEnabled $true -MailNickName "admin" -UsageLocation "GB" }

$UPN = "Isaiah.Langer@" + $tenant
New-AzureADUser -DisplayName "Isaiah Langer" -PasswordProfile $PasswordProfile -UserPrincipalName $UPN -AccountEnabled $true -MailNickName "IsaiahL" -UsageLocation "US"
$UPN = "Alex.Wilber@" + $tenant
New-AzureADUser -DisplayName "Alex Wilber" -PasswordProfile $PasswordProfile -UserPrincipalName $UPN -AccountEnabled $true -MailNickName "AlexL" -UsageLocation "US"
