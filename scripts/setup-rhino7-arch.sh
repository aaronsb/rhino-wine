#!/bin/bash

# Check if running on Arch Linux
if ! command -v pacman &> /dev/null; then
    echo "Error: This script requires pacman package manager. Are you running Arch Linux?"
    exit 1
fi

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo "Error: This script requires yay AUR helper. Please install yay first."
    exit 1
fi

echo "Installing Wine and basic dependencies..."
sudo pacman -S --noconfirm wine wine-gecko wine-mono winetricks

echo "Installing Wine Staging from AUR..."
yay -S --noconfirm wine-staging

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

echo "Installing additional recommended packages..."
sudo pacman -S --noconfirm gamemode lib32-gamemode

# Graphics drivers installation prompt
echo "Would you like to install graphics drivers? [y/N]"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    echo "Select your graphics card:"
    echo "1) NVIDIA"
    echo "2) AMD"
    echo "3) Intel"
    read -r choice
    case $choice in
        1)
            sudo pacman -S --noconfirm nvidia nvidia-utils lib32-nvidia-utils
            ;;
        2)
            sudo pacman -S --noconfirm mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon
            ;;
        3)
            sudo pacman -S --noconfirm mesa lib32-mesa vulkan-intel lib32-vulkan-intel
            ;;
        *)
            echo "Invalid choice. Skipping graphics driver installation."
            ;;
    esac
fi

echo "Setup complete! You can now download and install Rhino 7."
echo "After downloading, run: wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe"
