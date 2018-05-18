while ((Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId).Status -ne 'completed') {
Write-Host 'Waiting for image to import...'
Start-Sleep -Seconds 10
}
Write-Host 'Image import complete!'
