dbeaverteam)
    name="DBeaverTeam"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dbeaver.com/files/dbeaver-te-latest-macos-aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dbeaver.com/files/dbeaver-te-latest-macos-x86_64.dmg"
    fi
    appNewVersion=$(curl -fsI -o /dev/null -w '%{redirect_url}' "$downloadURL" | sed -E 's|.*/dbeaver-te-([0-9]+(\.[0-9]+)+)-macos-(aarch64|x86_64)\.dmg|\1|')
    expectedTeamID="42B6MDKMW8"
    blockingProcesses=( dbeaver )
    ;;
