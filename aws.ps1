#$secretkey = ConvertTo-SecureString $Env:AWS_SECRET_ACCESS_KEY -AsPlainText -Force
#$accesskey = ConvertTo-SecureString $Env:AWS_ACCESS_KEY_ID -AsPlainText -Force
Set-AWSCredential -AccessKey "$env:AWS_ACCESS_KEY_ID" -SecretKey "$env:AWS_SECRET_ACCESS_KEY"  -StoreAs UttamProfile2
$container = New-Object Amazon.EC2.Model.ImageDiskContainer
$container.Format = 'VHD'
$container.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container.UserBucket.S3Bucket = 'migration-azure-tcs'
$container.UserBucket.S3Key = 'X:/testrhel.vhd'
$params = @{ ClientToken = 'idempotencyToken'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container }
$task = Import-EC2Image @params -ProfileName UttamProfile2
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId
