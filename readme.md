Install Rhino 7 on Ubuntu based OS (KDE on Jammy in this case)

⚠**This assumes a non existant wine prefix or even a wine installation. If you have an existing wine prefix there may be things that interfere with this guide.**

* [ ] Start by installing wine and some required adjacent libraries. 

``sudo apt install wine wine32 winetricks mono-complete winbind``

* [ ] Initialize your default Wine environment (which will be located under ~/.wine

``wineboot -u``

* [ ] install gecko browser for wine (required for license config to work)

``mkdir ~/.cache/wine``

``cd ~/.cache/wine``

``wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi``

``wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi``

``wineboot``


* [ ] various winetricks commands will log a lot of errors and warnings and yet still work. (Task Failed Successfuly?) so don't get too worried

``winetricks --force dotnet48``

* [ ] Click "restart now" lol
* [ ] kill all existing wine services so reg server doesn't get messed up.

``kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')``

* [ ] Install needed fonts. (personally, I think the missing fonts seems to kill Rhino on Wine the most)

``winetricks allfonts``

* [ ] A few more winetricks to install here.

``winetricks vulkanrt``

``winetricks dxvk``

``winetricks gdiplus``


* [ ] Force wine to appear as Windows 10

Sometimes this hangs, so control-c to break back to terminal prompt if necessary.

``wine winecfg -v win10``



The only libraries in Wine Configuration (winecfg) should be the following:

1. *gdiplus (native)

2. *mscoree (native)

**No other libraries should be present**

* [ ] Navigate to libraries and do the dirty work 🔪

``winecfg``

* [ ] Set renderer to gdi - although Rhino still uses gpu acceleration? this part is magic to me. ✨

``winetricks renderer=gdi``

* [ ] 🔪 Kill all existing remaining wine processes. This can be done in any terminal in your current session. (bash/zsh)

`kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')`

* [ ] Download latest Rhino 7 installer and run it. (Filename might change here)

`wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe`

* [ ] Installer will appear to exit, but it won't actually - it leaves the installer stub and main installer running.
* [ ] 🔪 Kill all remaining wine processes again. Do this from another terminal window if it pleases you. (bash/zsh)

`kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')`

* [ ] A Rhino 7 shortcut should appear on your desktop, you can just use that link to start it after finishing this process.
* [ ] Change to installed Rhino directory and run rhino

``cd ~/.wine/drive_c/Program Files/Rhino 7/System``

``wine rhino.exe``

* [ ] First time running rhino.exe brings up the installer dialog (the one asking to reinstall or repair). I've tried this a few times and it's repeatable, so just close the dialog box with the upper right X. The web based license process will then proceed.
* [ ] Type your email in and log in via your regular web browser

The license service is listening on tcp:1717 for the authorization string - depending on your system configuration (firewall), the request url to authorize the license will be an http on loopback tcp:1717, so that traffic needs to be allowed.

* [ ] Answer/dismiss the usage tracking dialog
* [ ] Run Grasshopper from within Rhino and select any example document to start it.
* [ ] Grasshopper font mapper will announce that Segoe Print is not available. Confirm the suggested alternative, Tahoma

Now, use Rhino! Save your work often, this isn't a supported configuration and it could crash in unexpected ways. From this point, I have been using Rhino for some projects that aren't exotic - default out of the box features. It works for me so far without much drama.

You might want to change your UI DPI in winecfg (I brought mine up to 133 DPI for my 4K monitor), and definitely experiment with customizing the settings in UI and font to your taste.

Notes and ideas.

Using wine-staging (7.1) I can use vulkan, gl, gdi, or no3d. They all appear to have similar performance and all seem to use the gpu for in-UI viewport rendering. Using any other renderer besides gdi or no3d causes user interface artifacts such as black regions around some dialog and UI elements. Currently it seems using GDI has the least artifacts when using the application.

I definitely think staging 7.1 has less overall glitchy stuff going on such as viewport refresh issues.

I installed nvidia cuda support, and my system shows cuda available, but rhino does not detect cuda capability passeed to it from wine(-staging). I had read that staging has better cuda support.

* [x] Get vulkan renderer to work
* [ ] Get some sort of acceleration for cycles so rendering is useful.
* [ ] Get the auto updater to auto update reliably.
