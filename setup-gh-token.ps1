# Inkline GitHub Token Setup Helper
# This script sets up GH_TOKEN as a Windows environment variable for auto-updates

Write-Host "======================================" -ForegroundColor Cyan
Write-Host "Inkline - GitHub Token Setup" -ForegroundColor Cyan
Write-Host "======================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "This app uses GitHub Releases for auto-updates." -ForegroundColor Yellow
Write-Host "To enable auto-updates, provide your GitHub personal access token." -ForegroundColor Yellow
Write-Host ""

$token = Read-Host "Enter your GitHub token (or press Enter to skip)"

if ($token -ne "") {
    # Validate token format (basic check)
    if ($token.StartsWith("ghp_") -or $token.StartsWith("github_")) {
        try {
            # Set user environment variable
            [System.Environment]::SetEnvironmentVariable("GH_TOKEN", $token, "User")
            Write-Host ""
            Write-Host "✓ Token saved successfully!" -ForegroundColor Green
            Write-Host "The environment variable GH_TOKEN has been set." -ForegroundColor Green
            Write-Host ""
            Write-Host "IMPORTANT: Please restart Inkline for changes to take effect." -ForegroundColor Yellow
        } catch {
            Write-Host "✗ Error setting environment variable: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "✗ Invalid token format. GitHub tokens start with 'ghp_' or 'github_'" -ForegroundColor Red
    }
} else {
    Write-Host "Skipped. You can set GH_TOKEN later using:" -ForegroundColor Yellow
    Write-Host '  [Environment]::SetEnvironmentVariable("GH_TOKEN", "your_token", "User")' -ForegroundColor White
    Write-Host ""
    Write-Host "Or manually via System Properties > Environment Variables" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "For more info, visit: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to exit"
