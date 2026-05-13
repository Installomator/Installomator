handy)
    name="Handy"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(downloadURLFromGit "cjpais" "Handy")
        appNewVersion=$(versionFromGit "cjpais" "Handy")
    else
        archiveName="x64.dmg"
        downloadURL=$(downloadURLFromGit "cjpais" "Handy")
        appNewVersion=$(versionFromGit "cjpais" "Handy")
    fi
    expectedTeamID="UWFLB4GC25"
    ;;
