workbrew)
    name="Workbrew"
    type="pkg"
    downloadURL="https://console.workbrew.com/downloads/macos"
    appNewVersion="$(curl -sIL https://console.workbrew.com/downloads/macos | grep -i "^content-disposition:" | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')"
    appCustomVersion(){ /opt/workbrew/bin/brew --version | grep "Workbrew " | awk '{ print $2 }' | cut -d'-' -f1 }
    expectedTeamID="676JW3JDLF"
    ;;
