#!/bin/zsh
################################################################################
# @Author: Alexander Duffner <duf0002a>
# @Date:   2023-05-17T14:49:12+02:00
# @Email:  Alexander.Duffner@prosiebensat1.com
# @Filename: cinema4d.sh
# @Last modified by:   duf0002a
# @Last modified time: 2023-05-17T14:49:24+02:00
################################################################################

cinema4d)
    name="Cinema 4D"
    type="dmg"
    appCustomVersion(){
      defaults read "/Applications/Maxon Cinema 4D 2023/Cinema 4D.app/Contents/Info.plist" \
      CFBundleGetInfoString | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+"
    }
    appNewVersion="$(
      curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" \
        -fs "https://support.maxon.net/hc/en-us/sections/4405723907986-Cinema-4D" | grep "#icon-star" -B3 | grep \
        -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru
    )"
    targetDir="/Applications/Maxon Cinema 4D ${appNewVersion:0:4}"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/cinema4d/releases/${appNewVersion}/Cinema4D_${appNewVersion:0:4}_${appNewVersion}_Mac.dmg"
    installerTool="Maxon Cinema 4D Installer.app"
    CLIInstaller="Maxon Cinema 4D Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
