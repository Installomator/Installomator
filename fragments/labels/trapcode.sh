trapcode)
    name="Trapcode Suite"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep trapcode | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | sort -gru | head -n 1
    }
    for i in {1..5}; do
      appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Trapcode" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
      if [[ -n $appNewVersion ]]; then break; else sleep 1; fi
    done
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/trapcode/releases/${appNewVersion}/TrapcodeSuite-${appNewVersion}_Mac.zip"
    trapcodeResponse=$(curl -s -I -L "$downloadURL")
    trapcodeHttpStatus=$(echo "$trapcodeResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "trapcodeHttpStatus" == "200" ]]; then
      printlog "DownloadURL HTTP status code: $trapcodeHttpStatus" INFO
    elif [[ "$trapcodeHttpStatus" == "404" ]]; then
      downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/trapcode/releases/${appNewVersion}/TrapcodeSuite-${appNewVersion}_mac.zip"
      printlog "Had to change DownloadURL due HTTP Status." INFO
    else
      printlog "Unexpected HTTP status code: $trapcodeHttpStatus" ERROR
    fi
    installerTool="Trapcode Suite Installer.app"
    CLIInstaller="Trapcode Suite Installer.app/Contents/MacOS/Trapcode Suite Installer"
    expectedTeamID="4ZY22YGXQG"
    ;;
