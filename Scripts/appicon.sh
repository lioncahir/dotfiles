#!/bin/bash

# Use case: Replacing icon for a single application while keeping existing icon theme in XFCE.
# In XFCE you can change icon manually (e.g. in MenuLibre) and in the launcher, but the window manager will still pick up theme icon to show on panel
# when application is started. Workaround is to re-create the icon folders in ~/.icons and copy the desired application icon there (e.g. firefox)
# Usage: 
# 1. Download application icon (in SVG) and store in your Downloads directory
# 2. Name of the icon must match application, e.g. firefox.svg
# 3. Run script with application name as parameter, e.g. appicon.sh firefox
#
# To revert the changes, navigate to ~/.icons/<themename>/apps folder in Terminal and run:
# find . -name "<iconname>.svg" -exec rm {} \;

if [ $# -eq 0 ]
  then
    echo -e "\nApplication name missing. Example: appicon.sh firefox\n"
    exit 1
  else
    app_name=$1
fi

app_icon=$(xdg-user-dir DOWNLOAD)/$app_name.svg

if [ ! -f $app_icon ]
  then
    echo -e "\nError: Cannot find icon file $app_icon\n"
    exit 1
fi

sizes=("16" "16@2x" "22" "22@2x" "24" "24@2x" "32" "32@2x" "48" "48@2x" "64" "64@2x" "96" "96@2x" "256" "256@2x")
theme=$(gsettings get org.gnome.desktop.interface gtk-theme)
theme=${theme//\'/}

for size in ${sizes[@]}; do
  mkdir -pv ~/.icons/$theme/apps/$size
  cp -v $app_icon ~/.icons/$theme/apps/$size/
done

echo -e "\nApplication icon for $1 has been changed successfully in $HOME/.icons/$theme/apps\n"




