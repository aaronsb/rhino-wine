#!/bin/bash

# Check if running on Debian/Ubuntu
if ! command -v apt &> /dev/null; then
    echo "Error: This script requires apt package manager. Are you running Debian/Ubuntu?"
    exit 1
fi

echo "Updating package lists..."
sudo apt update

echo "Installing Wine and dependencies..."
sudo apt install -y wine wine32 winetricks mono-complete winbind

echo "Initializing Wine environment..."
wineboot -u

echo "Installing Wine Gecko..."
mkdir -p ~/.cache/wine
cd ~/.cache/wine
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
wineboot

echo "Installing .NET 4.8..."
winetricks --force dotnet48

echo "Cleaning up Wine processes..."
kill -9 $(ps aux | grep -i '\.exe' | awk '{print $2}' | tr '\n' ' ') 2>/dev/null

echo "Installing fonts..."
winetricks allfonts

echo "Installing additional libraries..."
winetricks vkd3d dxvk gdiplus

echo "Configuring Wine settings..."
winetricks orm=backbuffer
wine winecfg -v win11
winetricks renderer=gdi

echo "Setting up Direct3D renderer to Vulkan..."
reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v renderer /t REG_SZ /d vulkan /f

echo "Disabling theme for tooltip compatibility..."
reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ThemeManager' /v ThemeActive /t REG_SZ /d 0 /f

echo "Installing GameMode..."
sudo apt install -y gamemode

# Gamemode installation prompt
echo "Would you like to install the gamemode package? [y/N]"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    sudo apt install -y gamemode
fi

echo "Setup complete! You can now download and install Rhino 7."
echo "After downloading, run: wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe"
