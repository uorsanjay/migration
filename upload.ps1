# echo $env:as_AccessKey
# echo $env:as_SecretKey 
$localVhdPath=Get-Content -Path filepath.txt
AWSCredential -AccessKey $as_AccessKey -SecretKey $as_SecretKey -StoreAs UttamProfile2
Write-S3Object -BucketName migration-azure-tcs -File $localVhdPath -Key X:\testrhel.vhd -ProfileName UttamProfile2
$container1 = New-Object Amazon.EC2.Model.ImageDiskContainer
$container1.Format = 'VHD'
$container1.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container1.UserBucket.S3Bucket = 'migration-azure-tcs'
$container1.UserBucket.S3Key = 'X:/testrhel.vhd'
$params3 = @{ ClientToken = 'idempotencyToken2'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container1 }
Import-EC2Image @params3 -ProfileName UttamProfile2
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId

