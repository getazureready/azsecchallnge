Write-Output "Enter the admin credentials for your tenant:"
$creds=Get-Credential 

sleep 3

   Connect-AzAccount -Credential $subcredential
   #Select-AzSubscription -Subscription "Azure Pass - Sponsorship"

   $rg = (new-azresourcegroup -name Contoso-IaaS -Location eastus).ResourceGroupName
   $rg2 = (new-azresourcegroup -name Contoso-PaaS2 -Location eastus).ResourceGroupName

   sleep 10

 New-AzResourceGroupDeployment -Name azSecChLab -ResourceGroupName $rg -TemplateUri https://raw.githubusercontent.com/getazureready/azsecchallnge/master/azuredeploy/azuredeploy.json
 #above command will take 8-10 mins and will throw DSC extension errors on VM1 and VM2

 sleep 10

## Old-command## $DestStorageAccount = $outputs.storageAccountName.Value
$DestStorageAccount = (Get-AzStorageAccount -ResourceGroupName $rg).StorageAccountName
$SourceStorageAccount = "infraseclab"
$destStorageKey = (Get-AzStorageAccountKey -ResourceGroupName $rg -accountName $DestStorageAccount).value[0]
$sasToken = "?sv=2017-04-17&sr=c&si=infraseclab&sig=ONnlr56sGeZt0Qekgs8NFHquG5gGZU2jaFRnKp4bdXM%3D"
$SourceStorageContext = New-AzStorageContext -StorageAccountName $SourceStorageAccount -SasToken $sasToken
$DestStorageContext = New-AzStorageContext -StorageAccountName $DestStorageAccount -StorageAccountKey $DestStorageKey
$SourceStorageContainer = 'infraseclab'
$DestStorageContainer = (new-azstoragecontainer -Name contoso -permission Container -context $DestStorageContext).name

 sleep 5

$Blobs = (Get-AzStorageBlob -Context $SourceStorageContext -Container $SourceStorageContainer)
foreach ($Blob in $Blobs)
{
   Write-Output "Moving $Blob.Name"
   Start-CopyAzureStorageBlob -Context $SourceStorageContext -SrcContainer $SourceStorageContainer -SrcBlob $Blob.Name `
      -DestContext $DestStorageContext -DestContainer $DestStorageContainer -DestBlob $Blob.Name
}

Write-Output "***** IaaS Lab Ready :-) *****"

new-azresourcegroupdeployment -Name azSecChpaasLab -ResourceGroupName $rg2 -TemplateUri https://raw.githubusercontent.com/getazureready/azsecchallnge/master/azuredeploy/azuredeploy-paas.json

Write-Output "***** Azure Security Challenge Lab Ready :-) *****"
