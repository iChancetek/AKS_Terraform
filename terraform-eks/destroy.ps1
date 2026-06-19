Write-Host "Starting complete infrastructure teardown..." -ForegroundColor Cyan

Write-Host "`nStep 1: Destroying main EKS infrastructure..." -ForegroundColor Yellow
terraform destroy -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Error "Main infrastructure destroy failed. Please check the errors above. Aborting."
    exit $LASTEXITCODE
}

Write-Host "`nStep 2: Destroying Terraform backend (S3 bucket and DynamoDB)..." -ForegroundColor Yellow
Set-Location -Path "bootstrap"
# Ensure the bootstrap module is initialized
terraform init
terraform destroy -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Error "Backend destroy failed. Please check the errors above."
    Set-Location -Path ".."
    exit $LASTEXITCODE
}

Set-Location -Path ".."
Write-Host "`nTeardown complete! All AWS resources and Terraform backend state have been removed." -ForegroundColor Green
