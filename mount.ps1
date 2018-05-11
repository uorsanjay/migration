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
Set-AWSCredential -ProfileName MyProfile1
Set-AWSCredential -AccessKey "$env:as_AccessKey" -SecretKey "$env:as_SecretKey" -StoreAs MyProfile1
Write-S3Object -BucketName migration-azure-tcs -File $localVhdPath -Key X:\testrhel.vhd -ProfileName MyProfile1
$container = New-Object Amazon.EC2.Model.ImageDiskContainer
$container.Format = 'VHD'
$container.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container.UserBucket.S3Bucket = 'migration-azure-tcs'
$container.UserBucket.S3Key = 'X:/testrhel.vhd'
$params = @{ ClientToken = 'idempotencyToken'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container }
$task = Import-EC2Image @params -ProfileName MyProfile1
Import-EC2Image @params -ProfileName MyProfile1
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId  -ProfileName MyProfile1
