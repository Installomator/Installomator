vfx)
    name="VFX Suite"
    type="zip"
    appCustomVersion(){
          ls "/Users/Shared/Red Giant/uninstall" | grep vfx | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | head -n 30 | sort -gru
    }
    appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Red Giant" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
    if [[ "$appNewVersion" =~ ^[^.]*\.[^.]*$ ]]; then
	    appNewVersion=$(sed 's/\([0-9]*\.[0-9]*\)/\1.0/' <<<"$appNewVersion")
    fi
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/vfx/releases/${appNewVersion}/VfxSuite-${appNewVersion}_Mac.zip"
    vfxResponse=$(curl -s -I -L "$downloadURL")
    vfxHttpStatus=$(echo "$vfxResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "$vfxHttpStatus" == "200" ]]; then
	    printlog "DownloadURL HTTP status code: $vfxHttpStatus" INFO
    elif [[ "$vfxHttpStatus" == "404" ]]; then
	    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/vfx/releases/${appNewVersion}/VfxSuite-${appNewVersion}_mac.zip"
	    printlog "Had to change DownloadURL due HTTP Status." INFO
    else
	    printlog "Unexpected HTTP status code: $vfxHttpStatus" ERROR
    fi
    installerTool="VFX Suite Installer.app"
    CLIInstaller="VFX Suite Installer.app/Contents/MacOS/VFX Suite Installer"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
