<#
.SYNOPSIS
    A script to make a copy of file(s) to another device via SSH and simultaneously back it up to the cloud.

.DESCRIPTION
    1. Checks if there are files to process in the source directory.
    2. Copies all files from the local folder to a mounted cloud drive backup folder (such as gdrive desktop).
    3. Securely copies the same files to a source destination using SSH and SCP.
    4. The script does NOT verify the transfer or delete the original files.
#>

# --- CONFIGURATION ---
# Please edit these variables before running the script.

# --- Paths and Connection Details ---
$user = "" # Your username on the destination device.
$localSourcePath = "" # Path to the dir with the files
$backupPath = "" # Path to the mounted cloud drive (like gdrive or onedrive)
$deviceHostName = "" # Destination device hostname for SSH
$destinationPath = "" # Path to the dir you want to put the files in

# --- DO NOT EDIT BELOW THIS LINE ---

# --- SCRIPT START ---

# Set error action to stop the script on any failure
$ErrorActionPreference = "Stop"

try {
    Write-Host "--- Starting File Copy Script ---" -ForegroundColor Cyan

    # Check if the source directory exists and has files
    if (-not (Test-Path -Path $localSourcePath)) {
        Write-Warning "Source directory not found: $localSourcePath. Exiting."
        exit
    }

    $sourceFiles = Get-ChildItem -Path $localSourcePath -File -Recurse
    if ($sourceFiles.Count -eq 0) {
        Write-Host "No files found in source directory. Nothing to do." -ForegroundColor Green
        exit
    }
    Write-Host "Found $($sourceFiles.Count) files to process."

    # --- STEP 1: Backup to Cloud Drive ---
    Write-Host "`n[Step 1/2] Backing up files to specified Drive..." -ForegroundColor Cyan
    Copy-Item -Path "$localSourcePath\*" -Destination $backupPath -Recurse -Force
    Write-Host "Backup complete." -ForegroundColor Green

    # --- STEP 2: Copying to destination via SCP ---
    Write-Host "`n[Step 2/2] Copying files to destination via SCP..." -ForegroundColor Cyan
    
    # Check SSH connection first
    try {
        ssh "$user@$deviceHostName" "echo 'SSH connection successful.'"
        if ($LASTEXITCODE -ne 0) { throw "SSH connection test failed." }
    } catch {
        Write-Error "Could not establish SSH connection to destination. Please ensure SSH is enabled on the device and powered on. Aborting."
        exit
    }

    # Use SCP to copy the files. The -r flag is for recursive.
    scp -r "$localSourcePath\*" "$user@$deviceHostName`:`"$destinationPath`""
    if ($LASTEXITCODE -ne 0) {
        Write-Error "SCP file transfer failed. Aborting."
        exit
    }
    Write-Host "SCP transfer complete." -ForegroundColor Green
    
    Write-Host "`n--- File copying complete ---" -ForegroundColor Cyan

} catch {
    Write-Error "An unexpected error occurred: $_"
    Write-Error "Script aborted."
}
