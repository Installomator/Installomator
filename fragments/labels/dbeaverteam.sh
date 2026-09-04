dbeaverteam)
    name="DBeaverTeam"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        dbeaverArch="aarch64"
    else
        dbeaverArch="x86_64"
    fi
    downloadURL="https://dbeaver.com/files/dbeaver-te-latest-macos-${dbeaverArch}.dmg"
    appNewVersion=$(curl -fsIL -o /dev/null -w "%{url_effective}" "$downloadURL" | sed -E 's#.*/team/([0-9]+(\.[0-9]+)+)/.*#\1#')
    expectedTeamID="42B6MDKMW8"
    ;;
