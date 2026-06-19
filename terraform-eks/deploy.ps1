Write-Host "Starting complete infrastructure deployment..." -ForegroundColor Cyan

Write-Host "`nStep 1: Bootstrapping Terraform backend (S3 bucket and DynamoDB)..." -ForegroundColor Yellow
Set-Location -Path "bootstrap"
terraform init
terraform apply -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Error "Backend bootstrap failed. Please check the errors above. Aborting."
    Set-Location -Path ".."
    exit $LASTEXITCODE
}
Set-Location -Path ".."

Write-Host "`nStep 2: Initializing main Terraform configuration..." -ForegroundColor Yellow
# We run init with migrate-state in case local state exists from prior runs
terraform init -migrate-state -force-copy

if ($LASTEXITCODE -ne 0) {
    Write-Error "Main infrastructure initialization failed. Aborting."
    exit $LASTEXITCODE
}

Write-Host "`nStep 3: Deploying main EKS infrastructure..." -ForegroundColor Yellow
terraform apply -auto-approve

if ($LASTEXITCODE -ne 0) {
    Write-Error "Main infrastructure deployment failed. Please check the errors above."
    exit $LASTEXITCODE
}

Write-Host "`nDeployment complete!" -ForegroundColor Green
Write-Host "To connect to your cluster, run:" -ForegroundColor Cyan
Write-Host "aws eks update-kubeconfig --region us-east-1 --name eks-prod" -ForegroundColor White
