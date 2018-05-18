while ((Get-EC2ImportImageTask -ImportTaskId $task.ImportTaskId).Status -eq 'completed') {
Write-Host 'Waiting for image to import...'
Start-Sleep -Seconds 10
}
Write-Host 'Image import complete!'
