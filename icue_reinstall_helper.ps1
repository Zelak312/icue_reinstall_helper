# iCUE Fix and Uninstall Script with Admin Check
# This script forces the closure of iCUE, stops relevant services, backs up the installation folder, and reinstalls the software.
# It will request admin permissions if not already running as an administrator.

$logFile = "$PSScriptRoot\iCUE_Uninstall_Log.txt"  # Log file in the script's running directory
$tempFolder = "$env:TEMP\iCUE_Installer"
$installerUrl = "https://www3.corsair.com/software/CUE_V5/public/modules/windows/installer/Install%20iCUE.exe"
$installerPath = "$tempFolder\Install_iCUE.exe"
$installDir = "C:\Program Files\Corsair\Corsair iCUE5 Software"
$backupDir = "$installDir" + "_backup"

# Check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Script is not running as administrator. Restarting with elevated privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Ensure the log directory exists
if (!(Test-Path -Path $tempFolder)) {
    New-Item -Path $tempFolder -ItemType Directory
}

function Log {
    param ($message)
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "$timeStamp : $message" | Tee-Object -FilePath $logFile -Append
}

function Stop-ServiceIfRunning {
    param ($serviceName)
    $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
    if ($service -and $service.Status -eq 'Running') {
        Stop-Service -Name $serviceName -Force
        Log "$serviceName was running and has been stopped."
    }
    else {
        Log "$serviceName is not running or doesn't exist."
    }
}

# Function to stop a kernel driver using sc.exe
function Stop-KernelDriver {
    param ($driverName)
    $driverStatus = (sc.exe query $driverName | Select-String "STATE" -SimpleMatch)
    if ($driverStatus -like "*RUNNING*") {
        Log "Stopping kernel driver: $driverName"
        sc.exe stop $driverName
        Log "$driverName has been stopped."
    }
    else {
        Log "$driverName is not running."
    }
}

function DownloadInstaller {
    param ($url, $destination)
    Log "Downloading iCUE installer from $url to $destination"
    Invoke-WebRequest -Uri $url -OutFile $destination
    Log "Download complete."
}

# 1. Ensure iCUE is closed
Log "Checking if iCUE is running..."
$process = Get-Process -Name "iCUE" -ErrorAction SilentlyContinue
if ($process) {
    Log "iCUE is running, attempting to close it..."
    Stop-Process -Name "iCUE" -Force
    Log "iCUE has been closed."
}
else {
    Log "iCUE is not running."
}

# 2. Stop services if they are running
$services = @("CorsairCpuIdService", "CorsairDeviceListerService", "iCUEUpdateService", "CorsairService")
foreach ($service in $services) {
    Stop-ServiceIfRunning -serviceName $service
}

# 3. Check for and stop the Corsair kernel drivers
$drivers = @("CorsairLLAccess")
foreach ($driver in $drivers) {
    Stop-KernelDriver -driverName $driver
}


# 4. Check if installation directory exists and back it up
if (Test-Path -Path $installDir) {
    Log "iCUE installation directory found. Backing up to $backupDir"
    Copy-Item -Path $installDir -Destination $backupDir -Recurse -Force
    Log "Backup complete."
}
else {
    Log "iCUE installation directory not found."
}

# 5. Try to remove the original installation directory
# Wait for a brief moment to ensure file handle is released
Log "Waiting 1 minute to make sure everything is closed"
Start-Sleep -Seconds 60

# Ensure the temp folder path is properly set
$tempMovePath = "$env:TEMP\CorsairLLAccess64.sys"

# Check if CorsairLLAccess64.sys is in the installation directory and move it
if (Test-Path -Path "$installDir\CorsairLLAccess64.sys") {
    Log "CorsairLLAccess64.sys found. Moving it to temp folder."

    try {
        # Move the locked file to the temp folder
        Move-Item -Path "$installDir\CorsairLLAccess64.sys" -Destination $tempMovePath -Force
        Log "CorsairLLAccess64.sys moved to $tempMovePath."
    }
    catch {
        Log "Failed to move CorsairLLAccess64.sys. Error: $_"
        Pause 
        exit
    }
}

if (Test-Path -Path $installDir) {
    Log "Attempting to remove iCUE installation directory."

    try {
        # Try removing the folder
        Remove-Item -Path $installDir -Recurse -Force -ErrorAction Stop
        Log "Installation directory removed successfully."
    }
    catch {
        Log "Failed to remove installation directory. Error: $_"
        Pause
        exit
    }
}

# 6. Download the iCUE installer
if (Test-Path -Path $installerPath) {
    Log "Installer already exists at $installerPath, deleting to redownload."
    Remove-Item -Path $installerPath -Force
}
DownloadInstaller -url $installerUrl -destination $installerPath

# 7. Run the installer
Log "Running iCUE installer."
Log "Click on Repair (what I normally use) and select the installation as normal"

Start-Sleep -Seconds 5
Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
Log "iCUE installation completed. Have Fun :)"

Log "Script finished."
Pause