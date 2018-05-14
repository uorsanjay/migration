$container = New-Object Amazon.EC2.Model.ImageDiskContainer
$container.Format = 'VHD'
$container.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container.UserBucket.S3Bucket = 'migration-azure-tcs'
$container.UserBucket.S3Key = 'X:/testrhel.vhd'
$params = @{ ClientToken = 'idempotencyToken'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container }
$task = Import-EC2Image @params -ProfileName MyProfile1
Import-EC2Image @params -ProfileName MyProfile1
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId  -ProfileName MyProfile1
