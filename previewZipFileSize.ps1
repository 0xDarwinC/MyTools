<#
.SYNOPSIS
    Calculates the total uncompressed size of all .zip files within a specified folder.

.DESCRIPTION
    This script iterates through all .zip archives in a target folder. For each
    archive, it sums the uncompressed lengths of all the files contained within it.
    It maintains a running total and, upon completion, displays the total size
    in a human-readable format (GB, MB, KB, or Bytes).

    This is useful for previewing the disk space required to extract a large
    collection of zip files.

.NOTES
    You must specify the path to your folder of zip files in the script.
#>

# --- CONFIGURATION ---
# IMPORTANT: Replace the path below with the full path to your folder containing the .zip files.
# Example: $zipFolderPath = "your path"
$zipFolderPath = "your path"

# --- SCRIPT START ---

# Add the necessary .NET assembly to read zip file contents.
Add-Type -AssemblyName System.IO.Compression.FileSystem

# Check if the specified folder exists.
if (-not (Test-Path -Path $zipFolderPath -PathType Container)) {
    Write-Host "Error: The folder '$zipFolderPath' does not exist. Please update the path in the script." -ForegroundColor Red
    return
}

# Get all .zip files in the target folder.
$zipFiles = Get-ChildItem -Path $zipFolderPath -Filter *.zip -ErrorAction SilentlyContinue

if ($null -eq $zipFiles) {
    Write-Host "No .zip files were found in '$zipFolderPath'." -ForegroundColor Yellow
    return
}

$totalUncompressedSize = 0
$fileCount = $zipFiles.Count
$processedCount = 0

Write-Host "Analyzing $fileCount zip files in '$zipFolderPath'..." -ForegroundColor Cyan

# Loop through each zip file to calculate the total size.
foreach ($zipFile in $zipFiles) {
    $processedCount++
    Write-Host "($processedCount/$fileCount) Reading: $($zipFile.Name)"

    try {
        # Open the zip archive for reading.
        $archive = [System.IO.Compression.ZipFile]::OpenRead($zipFile.FullName)

        # Sum the uncompressed length of all entries in the archive.
        foreach ($entry in $archive.Entries) {
            $totalUncompressedSize += $entry.Length
        }

        # Close the archive to release the file handle.
        $archive.Dispose()
    }
    catch {
        Write-Host " ERROR: Could not read '$($zipFile.Name)'. It may be corrupt or not a valid zip file." -ForegroundColor Red
    }
}

# --- Format the final size into a human-readable string ---
$sizeFormatted = ""
if ($totalUncompressedSize -ge 1GB) {
    $sizeFormatted = "{0:N2} GB" -f ($totalUncompressedSize / 1GB)
}
elseif ($totalUncompressedSize -ge 1MB) {
    $sizeFormatted = "{0:N2} MB" -f ($totalUncompressedSize / 1MB)
}
elseif ($totalUncompressedSize -ge 1KB) {
    $sizeFormatted = "{0:N2} KB" -f ($totalUncompressedSize / 1KB)
}
else {
    $sizeFormatted = "$totalUncompressedSize Bytes"
}

# --- Display the final result ---
Write-Host "----------------------------------------" -ForegroundColor Green
Write-Host "Analysis Complete." -ForegroundColor Green
Write-Host "Total Uncompressed Size: $sizeFormatted"
Write-Host "----------------------------------------"
