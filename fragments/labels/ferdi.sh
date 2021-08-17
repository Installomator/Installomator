ferdi)
    name="Ferdi"
    type="zip"
    if [[ $(arch) == i386 ]]; then
    downloadURL=$(curl --silent --fail "https://api.github.com/repos/getferdi/ferdi/releases/latest" \
    | awk -F '"' "/browser_download_url/ && /mac.zip/ && ! /blockmap/ && ! /arm64-mac/ && ! /AppImage/{ print \$4 }")
    elif [[ $(arch) == arm64 ]]; then
    downloadURL=$(downloadURLFromGit getferdi ferdi )
    archiveName="arm64-mac.zip"
    fi    
    appNewVersion=$(versionFromGit getferdi ferdi )
    expectedTeamID="B6J9X9DWFL"
    ;;
