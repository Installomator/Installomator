atlassiancompanion)
    name="Atlassian Companion"
    type="dmg"
    downloadURL=$(curl -fsL https://confluence.atlassian.com/display/DOC/Install+Atlassian+Companion | sed -nE 's/.*(https:.*\.dmg)\".*/\1/p')
    appNewVersion=$(getJSONValue "$(curl -fsL https://update-nucleus.atlassian.com/Atlassian-Companion/291cb34fe2296e5fb82b83a04704c9b4/darwin/x64/RELEASES.json)" "currentRelease" )
    expectedTeamID="UPXU4CQZ5P"
    ;;

