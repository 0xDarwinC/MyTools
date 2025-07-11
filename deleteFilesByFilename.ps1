<#
.SYNOPSIS
    Automatically finds and deletes all files containing "____" in their
    name from a user-specified directory.

.DESCRIPTION
    This script is designed for bulk cleaning of files.
    1. The user specifies the target folder in the CONFIGURATION section.
    2. The script finds all files in that folder with "____" in the filename.
    3. It then deletes all matching files without prompting for each one.
    4. A final summary lists all the files that were deleted.

.NOTES
    WARNING: This script permanently deletes files. They will NOT go to the
    Recycle Bin. Use with caution.
    You MUST specify the path to your folder in the CONFIGURATION section below.
#>

# --- CONFIGURATION ---
# IMPORTANT: Replace the path below with the full path to your folder.
# Example: $TargetDirectory = "C:\Users\Darwin\Downloads\MyGames"
$TargetDirectory = "yourtargetdir"

# --- SCRIPT START ---

Clear-Host

# Verify the user-configured path exists.
if (-not (Test-Path -Path $TargetDirectory -PathType Container)) {
    Write-Host "CRITICAL ERROR: The folder specified does not exist." -ForegroundColor Red
    Write-Host "Please edit the script and set the `$TargetDirectory variable to a valid path." -ForegroundColor Red
    Write-Host "Path specified: '$TargetDirectory'" -ForegroundColor Yellow
    return
}

Write-Host "Searching for files with '_____' in the name in the following directory:" -ForegroundColor Cyan
Write-Host $TargetDirectory -ForegroundColor Yellow
Write-Host

# CHANGE BELOW TO CHOOSE WHAT TO DELETE -- Get all files containing "____" in their name. The filter is case-insensitive by default.
$demoFiles = Get-ChildItem -Path $TargetDirectory -Filter "*_____*" -File -Recurse -ErrorAction SilentlyContinue

if ($demoFiles.Count -eq 0) {
    Write-Host "SUCCESS: No files containing '(Beta)' were found." -ForegroundColor Green
    return
}

Write-Host "Found $($demoFiles.Count) demo files to delete. Deleting now..." -ForegroundColor Yellow
Write-Host "----------------------------------------------------"

$deletedFiles = @()

# Loop through each found file and delete it.
foreach ($file in $demoFiles) {
    try {
        Write-Host "Deleting: $($file.Name)" -ForegroundColor Red
        Remove-Item -Path $file.FullName -Force -ErrorAction Stop
        $deletedFiles += $file.Name
    }
    catch {
        Write-Host " -> ERROR: Could not delete '$($file.Name)'. It may be locked or permissions are denied." -ForegroundColor Magenta
    }
}

# --- Final Summary ---
Write-Host "----------------------------------------------------" -ForegroundColor Cyan
Write-Host "Deletion complete."
if ($deletedFiles.Count -gt 0) {
    Write-Host "Total files deleted: $($deletedFiles.Count)" -ForegroundColor Green
}
else {
    Write-Host "No files were deleted due to errors." -ForegroundColor Yellow
}
Write-Host "----------------------------------------------------"
