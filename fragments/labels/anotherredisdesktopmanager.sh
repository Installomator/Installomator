anotherredisdesktopmanager)
    name="Another Redis Desktop Manager"
    type="dmg"
    appNewVersion="$(versionFromGit qishibo AnotherRedisDesktopManager)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Another-Redis-Desktop-Manager-mac-${appNewVersion}-arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Another-Redis-Desktop-Manager-mac-${appNewVersion}-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit qishibo AnotherRedisDesktopManager)"
    expectedTeamID="68JN8DV835"
    ;;
