logseq)
    name="Logseq"
    type="dmg"
    if [[ $(arch) == i386 ]]; then
        downloadURL=$(curl --silent --fail "https://api.github.com/repos/logseq/logseq/releases/latest" \
        | awk -F '"' "/browser_download_url/ && /logseq-darwin/ && /.dmg/ && ! /arm64/ { print \$4 }") 
    elif [[ $(arch) == arm64 ]]; then
        downloadURL=$(downloadURLFromGit logseq logseq)
    fi
    appNewVersion=$(versionFromGit logseq logseq)
    expectedTeamID="3K44EUN829"
    ;;
