airflow)
    name="Air"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Air-arm64.dmg"

    elif [[ $(arch) == "i386" ]]; then
        archiveName="Air-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit AirLabsTeam airflow-releases)"
    appNewVersion="$(versionFromGit AirLabsTeam airflow-releases)"
    expectedTeamID="8RBYE8TY7T"
    ;;
