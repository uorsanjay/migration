


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
Set-AWSCredential -ProfileName MyProfileName13
AWSCredential -AccessKey "$as_AccessKey" -SecretKey "$as_SecretKey" -StoreAs MyProfileName13
Set-AWSCredential -AccessKey AKIAJGQOLAO2N5TT7O7A -SecretKey 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 -StoreAs MyProfileName1380214
Write-S3Object -BucketName migration-azure-tcs -File $localVhdPath -Key X:\testrhel.vhd -ProfileName MyProfileName1380214
$container2 = New-Object Amazon.EC2.Model.ImageDiskContainer
$container2.Format = 'VHD'
$container2.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container2.UserBucket.S3Bucket = 'migration-azure-tcs'
$container2.UserBucket.S3Key = 'X:/testrhel.vhd'
$params2 = @{ ClientToken = 'idempotencyToken2'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container2 }
$task = Import-EC2Image @params2 -ProfileName MyProfileName13
Import-EC2Image @params2 -ProfileName MyProfileName13
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId  -ProfileName MyProfileName13
