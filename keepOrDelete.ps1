<#
.SYNOPSIS
    Interactively deletes .zip files from a user-specified directory while
    providing a live preview of the total uncompressed size.

.DESCRIPTION
    This script is designed for intelligently clearing disk space.
    1. The user specifies the target folder in the CONFIGURATION section.
    2. The script calculates and displays the total uncompressed size of all
       .zip files in that folder.
    3. It then iterates through each .zip file, prompting the user with a single
       key press to either keep or delete it.
    4. After each deletion, it recalculates and displays the new total size.

.NOTES
    You MUST specify the path to your folder in the CONFIGURATION section below.
#>

# --- CONFIGURATION ---
# IMPORTANT: Replace the path below with the full path to your folder containing the .zip files.
# Example: $TargetDirectory = "your path"
$TargetDirectory = "your path"

# --- SCRIPT START ---

# Function to calculate the total uncompressed size of a list of zip files.
function Get-TotalUncompressedSize {
    param(
        [Parameter(Mandatory=$true)]
        [System.Collections.ArrayList]$ZipFileList
    )
    $totalSize = 0
    foreach ($zipFile in $ZipFileList) {
        try {
            $archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile.FullName)
            foreach ($entry in $archive.Entries) { $totalSize += $entry.Length }
            $archive.Dispose()
        } catch {} # Silently ignore corrupt files
    }
    return $totalSize
}

# Function to format bytes into a human-readable string (GB, MB, KB).
function Format-Size {
    param([long]$Bytes)
    if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return "{0:N2} KB" -f ($Bytes / 1KB) }
    return "$Bytes Bytes"
}

# --- Main Logic ---

Clear-Host
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Verify the user-configured path exists.
if (-not (Test-Path -Path $TargetDirectory -PathType Container)) {
    Write-Host "CRITICAL ERROR: The folder specified does not exist." -ForegroundColor Red
    Write-Host "Please edit the script and set the `$TargetDirectory variable to a valid path." -ForegroundColor Red
    Write-Host "Path specified: '$TargetDirectory'" -ForegroundColor Yellow
    return
}

$MyScriptName = $MyInvocation.MyCommand.Name
Write-Host "Searching for .zip files in the following directory:" -ForegroundColor Cyan
Write-Host $TargetDirectory -ForegroundColor Yellow
Write-Host

# Get an ArrayList of files from the specified directory.
$allZipFiles = [System.Collections.ArrayList]@(
    Get-ChildItem -Path $TargetDirectory -File |
    Where-Object { $_.Extension -ieq ".zip" }
)
if ($allZipFiles.Count -eq 0) {
    Write-Host "CRITICAL ERROR: Found 0 .zip files to process in the directory above." -ForegroundColor Red
    return
}

Write-Host "SUCCESS: Found $($allZipFiles.Count) .zip files to process." -ForegroundColor Green
Write-Host "Calculating initial size..." -ForegroundColor Cyan
$currentTotalSize = Get-TotalUncompressedSize -ZipFileList $allZipFiles
Write-Host "----------------------------------------------------" -ForegroundColor Green
Write-Host "Initial Uncompressed Size: $(Format-Size -Bytes $currentTotalSize)" -ForegroundColor Green
Write-Host "----------------------------------------------------"
Write-Host

$filesToProcess = $allZipFiles.Clone()
$deletedCount = 0

foreach ($file in $filesToProcess) {
    if (-not (Test-Path -Path $file.FullName)) { continue }

    Write-Host "Processing: $($file.Name) ==> [K]eep, [D]elete, [Q]uit? " -NoNewline
    $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    Write-Host

    switch ($key) {
        'd' {
            Write-Host " -> DELETING" -ForegroundColor Red
            try {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                $deletedCount++
                $itemToRemove = $allZipFiles | Where-Object { $_.FullName -eq $file.FullName }
                if ($null -ne $itemToRemove) { $allZipFiles.Remove($itemToRemove) }
                $currentTotalSize = Get-TotalUncompressedSize -ZipFileList $allZipFiles
                Write-Host " -> New Total Size: $(Format-Size -Bytes $currentTotalSize)" -ForegroundColor Yellow
            }
            catch { Write-Host " -> ERROR: Could not delete '$($file.Name)'." -ForegroundColor Magenta }
        }
        'q' {
            Write-Host " -> Quitting..." -ForegroundColor Cyan
            break
        }
        default { Write-Host " -> Keeping" -ForegroundColor Green }
    }
    Write-Host
}

# --- Final Summary ---
Write-Host "----------------------------------------------------" -ForegroundColor Cyan
Write-Host "File review complete."
Write-Host "  - Files deleted: $deletedCount"
Write-Host "  - Final Uncompressed Size: $(Format-Size -Bytes $currentTotalSize)" -ForegroundColor Green
Write-Host "----------------------------------------------------"
