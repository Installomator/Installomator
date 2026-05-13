workbrew)
    name="Workbrew"
    type="pkg"
    packageID="com.workbrew.Workbrew"
    downloadURL="https://console.workbrew.com/downloads/macos"
    appNewVersion="$(curl -ifs "https://console.workbrew.com/downloads/macos" | grep -o "Workbrew-[0-9].[0.9].[0-9][0-9].pkg" | grep -o "[0-9].[0.9].[0-9][0-9]")"
    appCustomVersion(){ /opt/workbrew/bin/brew --version | grep "Workbrew " | awk '{ print $2 }' | cut -d'-' -f1 }
    expectedTeamID="676JW3JDLF"
    ;;
