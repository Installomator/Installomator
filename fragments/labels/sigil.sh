sigil)
    name="Sigil"
    type="tbz"
    if [[ "$arch" == "arm64" ]]; then
        archiveName="Mac-arm64.txz"
    else
        archiveName="Mac-x86_64.txz"
    fi
    downloadURL=$(downloadURLFromGit Sigil-Ebook Sigil)
    appNewVersion=$(versionFromGit Sigil-Ebook Sigil)
    expectedTeamID="2SMCVQU3CJ"
    ;;
