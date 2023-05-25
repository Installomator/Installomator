vfx)
    name="VFX Suite"
    type="zip"
    appCustomVersion(){
      ls "/Users/Shared/Red Giant/uninstall" | grep vfx | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru
    }
    appNewVersion="$(curl -H "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" -fs "https://support.maxon.net/hc/en-us/sections/4406405445394-VFX-Suite" | grep "#icon-star" -B3 | grep -Eo "202[0-9]+\.[0-9]+\.[0-9]+" | head -n 30 | sort -gru)"
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/vfx/releases/${appNewVersion}/VfxSuite-${appNewVersion}_Mac.zip"
    installerTool="VFX Suite Installer.app"
    CLIInstaller="VFX Suite Installer.app/Contents/Scripts/install.sh"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
