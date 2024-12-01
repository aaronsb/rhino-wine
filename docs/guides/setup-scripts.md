# Setup Scripts

This guide provides information about the automated setup scripts for installing Rhino 7 on Arch Linux and Debian-based systems.

## Overview

The setup scripts automate the installation process described in the manual installation guides. They handle the installation of dependencies, Wine configuration, and optional graphics driver installation.

## Prerequisites

- For Arch Linux:
  - `pacman` package manager (comes with Arch)
  - `yay` AUR helper installed
  - Root privileges (sudo access)

- For Debian/Ubuntu:
  - `apt` package manager (comes with Debian/Ubuntu)
  - Root privileges (sudo access)

## Usage

1. Download the appropriate script for your system:
   - For Arch Linux: `setup-rhino7-arch.sh`
   - For Debian/Ubuntu: `setup-rhino7-debian.sh`

2. Make the script executable:
   ```bash
   chmod +x setup-rhino7-arch.sh   # For Arch Linux
   # OR
   chmod +x setup-rhino7-debian.sh # For Debian/Ubuntu
   ```

3. Run the script:
   ```bash
   ./setup-rhino7-arch.sh   # For Arch Linux
   # OR
   ./setup-rhino7-debian.sh # For Debian/Ubuntu
   ```

4. Follow the prompts during script execution:
   - The script will ask if you want to install graphics drivers
   - If yes, select your graphics card type (NVIDIA, AMD, or Intel)
   - For NVIDIA on Debian/Ubuntu, you'll need to specify the driver version

## What the Scripts Do

The setup scripts perform the following tasks:

1. Check for the appropriate package manager
2. Install Wine and required dependencies
3. Initialize Wine environment
4. Install Wine Gecko
5. Install .NET 4.8
6. Install required fonts
7. Install additional libraries (vkd3d, dxvk, gdiplus)
8. Configure Wine settings
9. Set up Direct3D renderer
10. Configure theme settings for tooltip compatibility
11. Install gaming performance tools (GameMode)
12. Optionally install graphics drivers

## After Setup

Once the script completes successfully:

1. Download Rhino 7 installer
2. Run the installer using Wine:
   ```bash
   wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe
   ```
3. Follow the Rhino installation process
4. Complete the licensing process

## Troubleshooting

If you encounter issues:

1. Check the terminal output for error messages
2. Ensure all prerequisites are met
3. Verify your system meets the minimum requirements for Rhino 7
4. Make sure you have a stable internet connection during setup

For specific issues:

- If Wine processes don't terminate properly, you can manually kill them:
  ```bash
  kill -9 $(ps aux | grep -i '\.exe' | awk '{print $2}' | tr '\n' ' ')
  ```
- If the graphics don't work correctly after installation, try changing the Direct3D renderer:
  ```bash
  reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v renderer /t REG_SZ /d vulkan /f
  ```

## Notes

- The scripts are designed to work with the latest versions of Arch Linux and Debian/Ubuntu
- Some commands may produce warnings or errors but still complete successfully
- The setup process may take significant time, especially during .NET 4.8 installation
- Save any work before running the scripts as they may require system restarts
