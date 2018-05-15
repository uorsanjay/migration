Set-AWSCredential -AccessKey AKIAJGQOLAO2N5TT7O7A -SecretKey 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 -StoreAs UttamProfile2
$container = New-Object Amazon.EC2.Model.ImageDiskContainer
$container.Format = 'VHD'
$container.UserBucket = New-Object Amazon.EC2.Model.UserBucket
$container.UserBucket.S3Bucket = 'migration-azure-tcs'
$container.UserBucket.S3Key = 'X:/testrhel.vhd'
$params = @{ ClientToken = 'idempotencyToken'; Platform = 'Linux'; LicenseType = 'BYOL'; DiskContainer = $container }
$task = Import-EC2Image @params -ProfileName UttamProfile2
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId
