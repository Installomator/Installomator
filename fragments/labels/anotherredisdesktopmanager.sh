anotherredisdesktopmanager)
    name="Another Redis Desktop Manager"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Another-Redis-Desktop-Manager-mac-1.7.1-arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Another-Redis-Desktop-Manager-win-1.7.1-x64.exe"
    fi
    type="dmg"
    downloadURL="$(downloadURLFromGit qishibo AnotherRedisDesktopManager)"
    appNewVersion="$(versionFromGit qishibo AnotherRedisDesktopManager)"
    expectedTeamID="68JN8DV835"
    ;;
