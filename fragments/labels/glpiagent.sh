glpiagent)
    name="GLPI-agent"
    type="pkg"
    packageID="com.teclib.glpi-agent"
    appNewVersion="$(versionFromGit glpi-project glpi-agent)"
    downloadURL="https://github.com/glpi-project/glpi-agent/releases/download/${appNewVersion}/GLPI-Agent-${appNewVersion}_"$(uname -m)".pkg"
    versionKey="CFBundleShortVersionString"  
    expectedTeamID="H7XJV96LX2"
    blockingProcesses=( NONE )
    ;;
