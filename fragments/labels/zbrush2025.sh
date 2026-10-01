zbrush2025)
    name="ZBrush"
    type="dmg"
    zbrushJSON=$(curl -fsL "https://support.maxon.net/api/v2/help_center/en-us/sections/7456686788252/articles.json")
    i=0; appNewVersion=""
    while articleTitle=$(getJSONValue "$zbrushJSON" "articles[$i].title" 2>/dev/null); do
        zbrushVersion=$(echo "$articleTitle" | sed -nE 's/^ZBrush (2025[.][0-9]+([.][0-9]+)?) Release Notes.*/\1/p')
        if [[ -n "$zbrushVersion" ]]; then
            zbrushURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/maxon/zbrush/releases/${zbrushVersion}/ZBrush_${zbrushVersion}_Installer.dmg"
            if curl -fsIL "$zbrushURL" >/dev/null; then
                appNewVersion="$zbrushVersion"
                downloadURL="$zbrushURL"
                break
            fi
        fi
        i=$((i + 1))
    done
    [[ -n "$downloadURL" ]] || cleanupAndExit 95 "could not determine latest verified ZBrush 2025 download URL" ERROR
    targetDir="/Applications/Maxon ZBrush 2025"
    installerTool="ZBrush_${appNewVersion}_Installer.app"
    CLIInstaller="ZBrush_${appNewVersion}_Installer.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=(--mode unattended --unattendedmodeui none)
    appCustomVersion(){ if [[ -f "/Applications/Maxon ZBrush 2025/ZBrush.app/Contents/Info.plist" ]]; then defaults read "/Applications/Maxon ZBrush 2025/ZBrush.app/Contents/Info.plist" CFBundleVersion 2>/dev/null | grep -Eo '2025[.][0-9]+([.][0-9]+)?'; fi; }
    expectedTeamID="4ZY22YGXQG"
    ;;
