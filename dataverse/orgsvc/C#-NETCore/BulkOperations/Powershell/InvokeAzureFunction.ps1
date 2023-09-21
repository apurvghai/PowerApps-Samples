# Start Time for Application

$StartDatetime = Get-Date;
Write-Host $StartDatetime.ToUniversalTime();
Write-Host "Simulating 2 worker threads x 20 degree of parallelism (20 threads)."
Write-Host "Triggering workers..."

#User Inputs
$functionAppName = Read-Host "Function App Name"
$records = Read-Host "Number Of Records"
$dop = Read-Host "Degree of Parallelism"
$batch = Read-Host "Batch Size"
$applicationUserId = Read-Host "Application User Id"
$applicationUserSecretKeyName = Read-Host "Application User Secret Key Name"


$baseUrl = "https://$functionAppName.azurewebsites.net/api/AzBulKOperations?code=zorf-koA4LLpL2qSsWgXFbmSeKKXlAbC3eDZqT-dwU5iAzFu3wtIXQ==&records=$records&dop=$dop&batch=$batch&applicationUserId=$applicationUserId&applicationUserIdKey=$applicationUserSecretKeyName&correlationId=24bd4ffa-9069-43c9-a863-83a4301be3f4";
	

Write-Host $baseUrl


# Example 1..100 to Simulate 100 workers

1..2 | ForEach-Object -ThrottleLimit 16 -Parallel {
	Write-Host "Trigger worker $_ ...starting"
	
	Invoke-WebRequest -Uri $using:baseUrl -Headers @{ "Content-Type" = "application/json"} -Method Get -Body $json -UseBasicParsing;

	Write-Host "Trigger worker $_...complete"
}

$Enddatetime = Get-Date;
Write-Host $Enddatetime.ToUniversalTime();