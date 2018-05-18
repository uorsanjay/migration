Set-AWSCredential -AccessKey "$env:AWS_ACCESS_KEY_ID" -SecretKey "$env:AWS_SECRET_ACCESS_KEY" -StoreAs UttamProfile2
Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId
write-Host 'Image import complete!'
