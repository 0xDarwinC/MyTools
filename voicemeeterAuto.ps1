<#
.SYNOPSIS
    Automated Restart Daemon for VoiceMeeter + Sony XM4.
    Includes configurable startup delay to ensure Audio Endpoints are ready.
#>

# --- CONFIGURATION (EDIT THESE) ---
$DeviceName   = "WH-1000XM4"
$VMProcess    = "voicemeeterpro"  # "voicemeeter" (Standard), "voicemeeterpro" (Banana), "voicemeeter8" (Potato)
$VMPath       = "C:\Program Files (x86)\VB\Voicemeeter\voicemeeterpro.exe"

# TUNING: How long to wait (in seconds) after killing VM before restarting it.
# Increase this if VoiceMeeter opens but still doesn't see the headphones.
$LaunchDelay = 0

# --- INITIALIZATION ---
Write-Host "Monitoring $DeviceName..." -ForegroundColor Cyan
Write-Host "Launch Delay set to: $LaunchDelay seconds" -ForegroundColor DarkGray
$LastConnectionState = $false

# --- MAIN DAEMON LOOP ---
while ($true) {
    # 1. Fetch Device & Property
    $dev = Get-PnpDevice -Class Bluetooth -FriendlyName $DeviceName -ErrorAction SilentlyContinue
    
    # 2. Check "IsConnected" Property (Deep Check)
    $IsConnected = $false
    if ($dev) {
        $prop = Get-PnpDeviceProperty -InstanceId $dev.InstanceId -KeyName "DEVPKEY_Device_IsConnected" -ErrorAction SilentlyContinue
        if ($prop.Data -eq $true) { $IsConnected = $true }
    }

    # 3. Trigger on Connection (False -> True)
    if ($IsConnected -and -not $LastConnectionState) {
        $TimeStamp = Get-Date -Format 'HH:mm:ss'
        Write-Host "[$TimeStamp] Headphones Connected." -ForegroundColor Yellow
        
        # A. Kill VoiceMeeter
        Write-Host "   > Stopping VoiceMeeter..." -NoNewline
        Stop-Process -Name $VMProcess -Force -ErrorAction SilentlyContinue
        Write-Host " Done." -ForegroundColor Gray
        
        # B. Restart VoiceMeeter
        if (Test-Path $VMPath) {
            Write-Host "   > Starting VoiceMeeter..."
            # Use Start-Process to ensure it detaches cleanly
            Start-Process -FilePath $VMPath -WindowStyle Normal
            Write-Host "   > [SUCCESS] Restart Complete." -ForegroundColor Green
        } else {
            Write-Host "   > [ERROR] Path not found: $VMPath" -ForegroundColor Red
        }
    }

    # 4. Update State & Poll
    $LastConnectionState = $IsConnected
    Start-Sleep -Seconds 3
}