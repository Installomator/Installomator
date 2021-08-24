amazonworkspaces)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Workspaces"
    type="pkg"
    downloadURL="https://d2td7dqidlhjx7.cloudfront.net/prod/global/osx/WorkSpaces.pkg"
    appNewVersion=$(curl -fs https://d2td7dqidlhjx7.cloudfront.net/prod/iad/osx/WorkSpacesAppCast_macOS_20171023.xml | grep -o "Version*.*<" | head -1 | cut -d " " -f2 | cut -d "<" -f1)
    expectedTeamID="94KV3E626L"
    ;;
