#!/bin/zsh --no-rcs

# how to remove Installomator.

# Mark: This fork
pkgutil --forget "com.scriptingosx.Installomator"
rm /usr/local/Installomator/Installomator.sh
rmdir /usr/local/Installomator

# Mark: Theile fork
pkgutil --forget "dk.theilgaard.pkg.Installomator"
rm /usr/local/bin/Installomator.sh
rm /usr/local/bin/InstallomatorLabels.sh
