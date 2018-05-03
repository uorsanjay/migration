# echo $env:az_password
# echo $env:az_username
$secpasswd = ConvertTo-SecureString $env:az_password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($env:az_username, $secpasswd)
Connect-AzureRmAccount -Credential $cred
