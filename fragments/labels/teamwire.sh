teamwire)
    name="Teamwire"
    type="dmg"
    packageID="eu.teamwire.app"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://desktop.teamwire.eu/download.php?platform=darwinArm64"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://desktop.teamwire.eu/download.php?platform=darwinX64"
    fi
    appNewVersion=$(curl -fsI $downloadURL | grep -i 'Location' | cut -d ' ' -f2 | sed 's|.*dist/v\([^/]*\).*|\1|')
    expectedTeamID="2JCSJ44B3U"
    ;;
