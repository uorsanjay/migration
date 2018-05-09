# echo $env:as_AccessKey
# echo $env:as_SecretKey 
$secpasswd = ConvertTo-SecureString $env:az_password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($env:az_username, $secpasswd)
Connect-AzureRmAccount -Credential $cred
$storageAccount = Get-AzureRmStorageAccount -ResourceGroupName CloudPractice -Name cloudpracticediag625
$storageKey = (Get-AzureRmStorageAccountKey -ResourceGroupName $storageAccount.ResourceGroupName -Name $storageAccount.StorageAccountName | select -first 1).Value
$storageContext = New-AzureStorageContext -StorageAccountName $storageAccount.StorageAccountName -StorageAccountKey $storageKey
$share = Get-AzureStorageShare -Name mymigrateshare -Context $storageContext
$secKey = ConvertTo-SecureString -String $storageKey -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($storageAccount.StorageAccountName, $secKey)
$shareDrive = New-PSDrive -Name X -PSProvider FileSystem -Root "\\$($storageAccount.StorageAccountName).file.core.windows.net\$($share.Name)" -Credential $credential -Persist
$localVhdPath=Get-Content -Path filepath.txt
Set-AWSCredential -AccessKey $env:as_AccessKey -SecretKey $env:as_SecretKey -StoreAs UttamProfile2
Write-S3Object -BucketName migration-azure-tcs -File $localVhdPath -Key X:\testrhel.vhd -ProfileName UttamProfile2
$container1 = New-Object Amazon.EC2.Model.ImageDiskContainer
$container1.Format = 'VHD'
$container1.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container1.UserBucket.S3Bucket = 'migration-azure-tcs'
$container1.UserBucket.S3Key = 'X:/testrhel.vhd'
$params3 = @{ ClientToken = 'idempotencyToken2'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container1 }
Import-EC2Image @params3 -ProfileName UttamProfile2
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId

