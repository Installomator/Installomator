#!/bin/bash

# This script is an MDM/management platform agnostic way to install Installomator
# The only requirement is an Internet connection.

# Get the URL of the latest PKG From the Installomator GitHub repo
url=$(curl --silent --fail "https://api.github.com/repos/Installomator/Installomator/releases/latest" | awk -F '"' "/browser_download_url/ && /pkg\"/ { print \$4; exit }")
# Expected Team ID of the downloaded PKG
expectedTeamID="JME5BW3F3R"
exitCode=0

# Check for Installomator and install if not found
if [ ! -e "/usr/local/Installomator/Installomator.sh" ]; then
  echo "Installomator not found. Installing."
  # Create temporary working directory
  workDirectory=$( /usr/bin/basename "$0" )
  tempDirectory=$( /usr/bin/mktemp -d "/private/tmp/$workDirectory.XXXXXX" )
  echo "Created working directory '$tempDirectory'"
  # Download the installer package
  echo "Downloading Installomator package"
  /usr/bin/curl --location --silent "$url" -o "$tempDirectory/Installomator.pkg"
  # Verify the download
  teamID=$(/usr/sbin/spctl -a -vv -t install "$tempDirectory/Installomator.pkg" 2>&1 | awk '/origin=/ {print $NF }' | tr -d '()')
  echo "Team ID for downloaded package: $teamID"
  # Install the package if Team ID validates
  if [ "$expectedTeamID" = "$teamID" ] || [ "$expectedTeamID" = "" ]; then
    echo "Package verified. Installing package Installomator.pkg"
    /usr/sbin/installer -pkg "$tempDirectory/Installomator.pkg" -target /
    exitCode=0
  else
    echo "Package verification failed before package installation could start. Download link may be invalid. Aborting."
    exitCode=1
    exit $exitCode
  fi
  # Remove the temporary working directory when done
  echo "Deleting working directory '$tempDirectory' and its contents"
  /bin/rm -Rf "$tempDirectory"
else
  echo "Installomator already installed."
fi

exit $exitCode
