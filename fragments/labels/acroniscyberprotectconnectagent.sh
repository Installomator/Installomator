acroniscyberprotectconnectagent|\
remotixagent)
    name="Acronis Cyber Protect Connect Agent"
    type="pkg"
    #packageID="com.nulana.rxagentmac"
    downloadURL="https://go.acronis.com/AcronisCyberProtectConnect_AgentForMac"
    versionKey="CFBundleVersion"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | sed -E 's/.*\/[a-zA-Z]*-[0-9.]*-([0-9.]*)\.pkg/\1/g')
    expectedTeamID="ZU2TV78AA6"
    blockingProcesses=( NONE )
    ;;
