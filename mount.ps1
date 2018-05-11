$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName CloudPractice -Name cloudpracticediag625
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName | select -first 1).Value
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
$share = Get-AzureStorageShare -Name mymigrateshare -Context $storageContext
$secKey = ConvertTo-SecureString -String $storageKey -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($storageAccount.StorageAccountName, $secKey)
$shareDrive = New-PSDrive -Name X -PSProvider FileSystem -Root "\\$($storageAccount.StorageAccountName).file.core.windows.net\$($share.Name)" -Credential $credential -Persist
$vm = Get-AzureRmVM -Name testrhel -ResourceGroupName CloudPractice
$vhdUri = $vm.StorageProfile.OsDisk.Vhd.Uri
$localVhdPath = "$($shareDrive.Name):\$($vm.Name).vhd"
Save-AzureRmVhd -LocalFilePath $localVhdPath -ResourceGroupName $vm.ResourceGroupName -SourceUri $vhdUri -NumberOfThreads 32 -OverWrite
# echo $env:as_AccessKey
# echo $env:as_SecretKey 
Set-AWSCredential -ProfileName MyProfileName138
Set-AWSCredential -AccessKey "$as_AccessKey" -SecretKey "$as_SecretKey" -StoreAs MyProfileName138
Write-S3Object -BucketName migration-azure-tcs -File $localVhdPath -Key X:\testrhel.vhd -ProfileName MyProfileName138
$container = New-Object Amazon.EC2.Model.ImageDiskContainer
$container.Format = 'VHD'
$container.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container.UserBucket.S3Bucket = 'migration-azure-tcs'
$container.UserBucket.S3Key = 'X:/testrhel.vhd'
$params4 = @{ ClientToken = 'idempotencyToken4'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container2 }
$task = Import-EC2Image @params -ProfileName MyProfileName138
Import-EC2Image @params4 -ProfileName MyProfileName138
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId  -ProfileName MyProfileName138
