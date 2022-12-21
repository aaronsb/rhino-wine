# This assumes a non existant wine prefix or even a wine installation. If you have an existing wine prefix there may be things that interfere

sudo apt install wine wine32 winetricks mono-complete winbind
wineboot -u

#install gecko browser for wine (required for license config to work)
mkdir ~/.cache/wine
cd ~/.cache/wine
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86_64.msi
wget http://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-x86.msi
wineboot

# various winetricks commands will log a lot of errors and warnings and yet still work. (Task Failed Successfuly?) so don't get too worried

winetricks --force dotnet48
# click "restart now" lol

# kill all existing wine services so reg server doesn't get messed up.
kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')

winetricks allfonts
# a couple clicks to install things here.
winetricks vulkanrt
winetricks dxvk
winetricks gdiplus

wine winecfg -v win10
# sometimes this hangs, so control c to exit

# remove ALL libararies in Wine Configuration (winecfg) EXCEPT the following
# *gdiplus (native)
# *mscoree (native)
# no other libraries should be present
# so, navigate to libraries and do the dirty work

winecfg 

# set renderer to no3d - although rhino still uses gpu acceleration? this part is magic to me.

winetricks renderer=no3d

# kill all existing wine stuff
kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')


# download latest rhino 7 installer and run it
wine ~/Downloads/rhino_en-us_7.24.22308.15001.exe

# installer will appear to exit, but it won't actually - it leaves the installer stub and main installer running.
# kill all remaining processes again. Do this from another terminal window if it pleases you
kill -9 $(ps aux |grep -i '\.exe' |awk '{print $2}'|tr '\n' ' ')

# a Rhino 7 shortcut should appear on your desktop, you can just use that link to start it after finishing this process.

# change to installed Rhino directory and run rhino

cd ~/.wine/drive_c/Program Files/Rhino 7/System
wine rhino.exe

# first time it does this the old installer dialog comes up for me (the one asking to reinstall or repair). I've tried this a few times and it's repeatable.
# just close the dialog box with the upper right x.
# the web based license process will then proceed.
# type your email in and log in via your regular web browser

# the license service is listening on tcp:1717 for the authorization string.
# depending on your system configuration (firewall), the request url to authorize the license will be an http on loopback tcp:1717, so that traffic needs to be allowed


# answer/dismiss the usage tracking dialog
# run grasshopper and select any example document
# Grasshopper font mapper will announce that Segoe Print is not available. Confirm the suggested alternative, Tahoma



