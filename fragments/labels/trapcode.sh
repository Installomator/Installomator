trapcode)
    name="Trapcode Suite"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep trapcode | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru
    }
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/articles/8642154839580" | grep "current_record_title" | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/trapcode/releases/${appNewVersion}/TrapcodeSuite-${appNewVersion}_mac.zip"
    installerTool="Trapcode Suite Installer.app"
    CLIInstaller="Trapcode Suite Installer.app/Contents/MacOS/Trapcode Suite Installer"
    expectedTeamID="4ZY22YGXQG"
    ;;
