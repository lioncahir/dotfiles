#!/bin/bash

echo "Downloading ZOOM deb file"
echo
cd $(xdg-user-dir DOWNLOAD)

if [ -f zoom_amd64.deb ]; then
    echo -e "Deleting old file\n"
    rm zoom_amd64.deb
fi

wget https://zoom.us/client/latest/zoom_amd64.deb
sudo apt deb ./zoom_amd64.deb
