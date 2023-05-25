universe)
    name="Universe"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep universe | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru
    }
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/4406405441426-Universe" | grep "#icon-star" -B3 | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/universe/releases/${appNewVersion}/Universe-${appNewVersion}_Mac.zip"
    installerTool="Universe Installer.app"
    CLIInstaller="Universe Installer.app/Contents/MacOS/Universe Installer"
    expectedTeamID="4ZY22YGXQG"
    ;;
