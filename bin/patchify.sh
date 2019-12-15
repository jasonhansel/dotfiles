#!/bin/bash
set -euo pipefail
cd /tmp
cp -f ~/.spotify-theme.css /tmp/spotify-theme.css
for SPA in /opt/spotify/Apps/*.spa
do
	sudo zip -r $SPA spotify-theme.css
	if unzip -o -d /tmp $SPA index.html
	then
		echo Running $SPA
		echo '<link rel="stylesheet" href="spotify-theme.css">' >> /tmp/index.html
# Reenable the below to patch html
	#	sudo zip -r $SPA index.html
	fi
done
