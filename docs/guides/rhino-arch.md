# Install Rhino 7 on Arch Linux using Wine 9.20 (Staging)

⚠**This assumes a non-existent wine prefix or even a wine installation. If you have an existing wine prefix there may be things that interfere with this guide.**

* [ ] Start by installing wine and required dependencies. We'll use both official repos and AUR:

```bash
# Install wine and basic dependencies from official repos
sudo pacman -S wine wine-gecko wine-mono winetricks

# Install additional dependencies from AUR (using yay)
yay -S wine-staging
```

* [ ] Initialize your default Wine environment (which will be located under ~/.wine)

```bash
wineboot -u
```

* [ ] Install gecko browser for wine (required for license config to work)

```bash
mkdir -p ~/.cache/wine
cd ~/.cache/wine
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
wineboot
```

* [ ] Various winetricks commands will log a lot of errors and warnings and yet still work. (Task Failed Successfully?) so don't get too worried

```bash
winetricks --force dotnet48
```

* [ ] Click "restart now" when prompted
* [ ] Kill all existing wine services so reg server doesn't get messed up.

```bash
kill -9 $(ps aux | grep -i '\.exe' | awk '{print $2}' | tr '\n' ' ')
```

* [ ] Install needed fonts. (The missing fonts seem to be a common cause of Rhino crashes on Wine)

```bash
winetricks allfonts
```

* [ ] Install additional required libraries

```bash
winetricks vkd3d dxvk gdiplus
```

* [ ] Set offscreen rendering to backbuffer

```bash
winetricks orm=backbuffer
```

* [ ] Force wine to appear as Windows 11 (required for compatibility)

Sometimes this hangs, so control-c to break back to terminal prompt if necessary.

```bash
wine winecfg -v win11
```

The only libraries in Wine Configuration (winecfg) should be the following:

1. *gdiplus (native)
2. *mscoree (native)

**No other libraries should be present**

* [ ] Navigate to libraries and verify the configuration

```bash
winecfg
```

* [ ] Set renderer to gdi - although Rhino still uses gpu acceleration? this part is magic ✨

```bash
winetricks renderer=gdi
```

* [ ] 🔪 Kill all existing remaining wine processes

```bash
kill -9 $(ps aux | grep -i '\.exe' | awk '{print $2}' | tr '\n' ' ')
```

* [ ] Download latest Rhino 7 installer and run it. (Filename might change here)

```bash
wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe
```

* [ ] Installer will appear to exit, but it won't actually - it leaves the installer stub and main installer running
* [ ] 🔪 Kill all remaining wine processes again. Do this from another terminal window if needed

```bash
kill -9 $(ps aux | grep -i '\.exe' | awk '{print $2}' | tr '\n' ' ')
```

* [ ] Before starting Rhino for the first time, there are some additional compatibility fixes that may be needed:

1. If you see black tooltips, you can fix this in one of two ways:
   - Open Wine Configuration (winecfg), go to Desktop Integration tab, and in Theme dropdown, select (No theme)
   - Or run this command:
   ```bash
   reg add 'HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\ThemeManager' /v ThemeActive /t REG_SZ /d 0 /f
   ```

2. If Rhino opens but windows are all black or fail to be drawn (OpenGL issue), fix it by changing Wine's Direct3D renderer:
   ```bash
   reg add 'HKEY_CURRENT_USER\Software\Wine\Direct3D' /v renderer /t REG_SZ /d vulkan /f
   ```
   Note: Valid renderer values are: gl, vulkan, gdi, no3d. Vulkan typically has the least artifacts.

* [ ] A Rhino 7 shortcut should appear on your desktop, you can use that link to start it after finishing this process
* [ ] Change to installed Rhino directory and run rhino

```bash
cd ~/.wine/drive_c/Program\ Files/Rhino\ 7/System
wine rhino.exe
```

* [ ] First time running rhino.exe brings up the installer dialog (asking to reinstall or repair). Close the dialog box with the upper right X. The web-based license process will then proceed.
* [ ] Type your email in and log in via your regular web browser

The license service is listening on tcp:1717 for the authorization string - depending on your system configuration (firewall), the request url to authorize the license will be an http on loopback tcp:1717, so that traffic needs to be allowed.

* [ ] Answer/dismiss the usage tracking dialog
* [ ] Run Grasshopper from within Rhino and select any example document to start it
* [ ] Grasshopper font mapper will announce that Segoe Print is not available. Confirm the suggested alternative, Tahoma

Now, use Rhino! Save your work often, this isn't a supported configuration and it could crash in unexpected ways. From this point, I have been using Rhino for some projects that aren't exotic - default out of the box features. It works without much drama.

You might want to change your UI DPI in winecfg (I brought mine up to 133 DPI for my 4K monitor), and definitely experiment with customizing the settings in UI and font to your taste.

## Notes and Ideas

Using wine 9.20, I can use vulkan, gl, gdi, or no3d. They all appear to have similar performance and all seem to use the gpu for in-UI viewport rendering. Using any other renderers causes various interface artifacts such as black regions around some dialog and UI elements. Currently it seems using Vulkan has the least artifacts when using the application.

Wine-staging has less overall glitchy behavior such as viewport refresh issues.

For NVIDIA users, while CUDA support can be installed via `sudo pacman -S cuda`, Rhino does not currently detect CUDA capability passed through wine-staging, even though staging has better CUDA support.

Render command seems fairly broken. Doesn't matter if it's new render or old render method. Render UI has black button regions and other artifacts.

### Todo
* [x] Get vulkan renderer to work
* [ ] Get some sort of acceleration for cycles so rendering is useful
* [ ] Get the auto updater to auto update reliably

### Arch-specific Notes
- If you encounter any font-related issues, ensure you have `ttf-ms-fonts` installed from the AUR: `yay -S ttf-ms-fonts`
- For better gaming/3D performance, consider installing `gamemode` and `lib32-gamemode`: `sudo pacman -S gamemode lib32-gamemode`
- If you experience any graphics issues, ensure you have the appropriate graphics drivers installed:
  - For NVIDIA: `sudo pacman -S nvidia nvidia-utils lib32-nvidia-utils`
  - For AMD: `sudo pacman -S mesa lib32-mesa xf86-video-amdgpu vulkan-radeon lib32-vulkan-radeon`
  - For Intel: `sudo pacman -S mesa lib32-mesa vulkan-intel lib32-vulkan-intel`
