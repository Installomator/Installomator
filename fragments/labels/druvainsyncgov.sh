druvainsyncgov)
    name="Druva inSync"
    type="pkgInDmg"
    druvaFeed=$(curl -fsL "https://downloads.druva.com/insync/js/data.json")
    appNewVersion=$(getJSONValue "$druvaFeed" "find(item => item.title === 'macOS' && item.installerDetails[0].downloadURL.includes('_Gov/')).installerDetails[0].version")
    downloadURL=$(getJSONValue "$druvaFeed" "find(item => item.title === 'macOS' && item.installerDetails[0].downloadURL.includes('_Gov/')).installerDetails[0].downloadURL")
    expectedTeamID="JN6HK3RMAP"
    ;;
