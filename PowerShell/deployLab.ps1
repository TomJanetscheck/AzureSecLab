$location = 'westeurope'
$vaultName = "keyvault-" + -join ((97..122) | Get-Random -Count 10 | % {[char]$_})
$resourceGroupName = (new-azurermresourcegroup -name aslab-IaaS -Location $location).ResourceGroupName

$keyVault = New-AzureRmKeyVault `
   -VaultName $vaultName `
   -ResourceGroupName $resourceGroupName `
   -Location $location `
   -EnabledForDeployment `
   -EnabledForTemplateDeployment  `
   -EnabledForDiskEncryption  `
   -EnableSoftDelete  `
   -Sku Standard
Wait-event -Timeout 30
Write-Host -ForegroundColor yellow "Keyvault $vaultName created..."
$secretValue = ConvertTo-SecureString 'Secur1tyR0cks' -AsPlainText -Force

$secret = Set-AzureKeyVaultSecret `
      -VaultName $vaultName `
      -Name 'labuser' `
      -SecretValue $secretValue

$outputs = (new-azurermresourcegroupdeployment `
      -Name AzureSecLab-Core `
      -ResourceGroupName $resourceGroupName `
      -TemplateUri https://azureseclab.blob.core.windows.net/azureseclab/azuredeploy-core.json `
      -VaultName $vaultName `
      -SecretName $secret.Name `
      -VaultResourceGroup $resourceGroupName `
      ).Outputs

$sourceStorageAccount = 'azureseclab'
$sasToken = '?sv=2017-07-29&ss=b&srt=sco&sp=rl&se=2018-12-31T22:59:59Z&st=2018-03-22T15:40:32Z&spr=https,http&sig=rX1ZIim1leUW%2B3JBRPlt9%2FdY0UxNPq0r9my5t8z7Ysk%3D'
$sourceStorageContext = New-AzureStorageContext –StorageAccountName $sourceStorageAccount -SasToken $sasToken
$sourceStorageContainer = 'labfiles'
$blobs = (Get-AzureStorageBlob -Context $sourceStorageContext -Container $sourceStorageContainer)
$destStorageAccount = $outputs.storageAccountName.Value
$destStorageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $resourceGroupName -accountName $destStorageAccount).value[0]
$destStorageContext = New-AzureStorageContext –StorageAccountName $destStorageAccount -StorageAccountKey $destStorageKey
$destStorageContainer = (new-azurestoragecontainer -Name labfiles -permission Container -context $destStorageContext).name

foreach ($blob in $blobs) {
      Write-Host "Moving $blob.Name" -ForegroundColor Yellow
      Start-CopyAzureStorageBlob `
            -Context $sourceStorageContext `
            -SrcContainer $sourceStorageContainer `
            -SrcBlob $blob.name `
            -DestContext $destStorageContext `
            -DestContainer $destStorageContainer `
            -DestBlob $blob.name
}

Write-Host "***** Azure Security Lab infrastructure is ready :-) *****" -ForegroundColor Green