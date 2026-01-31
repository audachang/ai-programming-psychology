# Check if Winget is available
if (-not (Get-Command "winget" -ErrorAction SilentlyContinue)) {
    Write-Error "Winget is not installed or not in PATH. Please install App Installer from Microsoft Store."
    exit 1
}

# 1. Check/Install Miniforge
Write-Host "Checking for Conda (Miniforge)..." -ForegroundColor Cyan
if (Get-Command "conda" -ErrorAction SilentlyContinue) {
    Write-Host "Conda is already installed." -ForegroundColor Green
} else {
    Write-Host "Conda not found. Installing Miniforge3 via Winget..." -ForegroundColor Yellow
    winget install --id CondaForge.Miniforge3 --exact --source winget --accept-package-agreements --accept-source-agreements
    
    # Refresh environment variables for the current session to find conda
    # This is a best-effort guess at the install location for the current user
    $userInstallPath = "$env:USERPROFILE\miniforge3"
    $systemInstallPath = "$env:ProgramData\miniforge3"
    
    if (Test-Path $userInstallPath) {
        $env:Path = "$userInstallPath\condabin;$userInstallPath\Scripts;$userInstallPath;$env:Path"
        Write-Host "Found Miniforge at $userInstallPath. Added to PATH." -ForegroundColor Green
    } elseif (Test-Path $systemInstallPath) {
        $env:Path = "$systemInstallPath\condabin;$systemInstallPath\Scripts;$systemInstallPath;$env:Path"
        Write-Host "Found Miniforge at $systemInstallPath. Added to PATH." -ForegroundColor Green
    } else {
        Write-Warning "Could not automatically locate Miniforge installation. You may need to restart your terminal to use 'conda'."
    }
}

# 2. Check if environment exists
Write-Host "`nChecking for existing 'psychopy_env'..." -ForegroundColor Cyan
$envExists = conda env list | Select-String "psychopy_env"

if ($envExists) {
    Write-Host "Environment 'psychopy_env' already exists." -ForegroundColor Yellow
} else {
    # 3. Create the environment
    if (Get-Command "conda" -ErrorAction SilentlyContinue) {
        Write-Host "Creating virtual environment 'psychopy_env' with Python 3.10..." -ForegroundColor Cyan
        conda create -n psychopy_env python=3.10 -y
        
        if ($?) {
             Write-Host "Environment created successfully." -ForegroundColor Green
        } else {
             Write-Error "Failed to create environment."
             exit 1
        }
    } else {
        Write-Error "Conda command not available even after attempted installation. Please restart your terminal and run this script again."
        exit 1
    }
}

# 4. Instructions
Write-Host "`n========================================================" -ForegroundColor White
Write-Host "                 SETUP COMPLETE" -ForegroundColor Green
Write-Host "========================================================" -ForegroundColor White
Write-Host "To start using PsychoPy:"
Write-Host "1. Restart your terminal (to ensure Conda is loaded)"
Write-Host "2. Run: conda activate psychopy_env"
Write-Host "3. Run: pip install psychopy"
Write-Host "========================================================" -ForegroundColor White
