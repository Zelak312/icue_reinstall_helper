# iCUE Reinstall Helper Script

## Language / Langue

[**English**](README.md) | [**Français**](README_fr.md)

## Overview

This PowerShell script helps you **reinstall iCUE** (Corsair's RGB control software) without requiring a reboot or safe mode. It forcefully closes the iCUE application, stops related services and drivers, backs up the installation directory, and reinstalls iCUE.

## Features

-   **Closes iCUE** if it's running.
-   **Stops related services and drivers** related to iCUE.
-   **Backs up iCUE installation directory**.
-   **Moves locked files** (like `CorsairLLAccess64.sys`) that can't be deleted.
-   **Deletes the iCUE directory**, even if it's locked or has locked files.
-   **Downloads and installs the latest iCUE version**.
-   **Logs all steps** and actions taken for debugging purposes.

## Requirements

-   **Administrator privileges**: The script will automatically request admin rights if it’s not already running with them.
-   **Internet connection**: The script will download the latest iCUE installer.

## Script Workflow

1. **Check if the script is running as Administrator**. If not, it will restart itself with elevated permissions.
2. **Close iCUE** if it's running.
3. **Stop iCUE-related services**.
4. **Stop kernel drivers** used by Corsair hardware.
5. **Backup the iCUE installation directory** to avoid data loss.
6. **Attempt to remove the installation directory**. If a file (like `CorsairLLAccess64.sys`) is locked, it will be moved to the temp folder before retrying the deletion.
7. **Download the iCUE installer** and **run the installer** to reinstall iCUE.
8. **Log all actions** for debugging and future reference.

## How to Use

1. **Download** the script (`icue_reinstall_helper.ps1`) to your local machine.
2. **Right-click** the script file and select **Edit**.
3. Paste and run this command in the blue powershell prompt `Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process`
4. Run the script using the green start button at the top
5. The script will ask for **Administrator permissions**. Grant the permissions for it to proceed.
6. The script will then **forcefully close iCUE**, stop related services and drivers, and attempt to remove the old iCUE directory.
7. If necessary, the script will **move locked files** to the temp folder and retry the removal of the directory.
8. Once the directory is successfully removed, the script will **download and install the latest iCUE** version.
9. After installation, the script will display a "Have Fun :)" message.

https://github.com/user-attachments/assets/9258fdca-2e41-423d-aafb-3d0e99a19d2a

## Contact

If you encounter any issues or have questions, you can contact me via:

-   **GitHub Issues**: [GitHub Repository](https://github.com/Zelak312/icue_reinstall_helper/issues)
-   **Discord**: `zelak`
