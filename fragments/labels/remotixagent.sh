remotixagent)
    name="RemotixAgent"
    type="pkg"
    packageID="com.nulana.rxagentmac"
    downloadURL="https://remotix.com/downloads/latest-agent-mac/"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)-.*\.pkg/\1/g' )
    expectedTeamID="K293Y6CVN4"
    ;;
