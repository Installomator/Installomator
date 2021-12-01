ferdi)
    name="Ferdi"
    type="zip"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="arm64-mac.zip"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="Ferdi-[0-9.]*-mac.zip"
    fi
    downloadURL="$(downloadURLFromGit getferdi ferdi)"
    appNewVersion=$(versionFromGit getferdi ferdi )
    expectedTeamID="B6J9X9DWFL"
    ;;
