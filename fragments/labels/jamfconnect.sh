jamfconnect)
    name="Jamf Connect"
    type="pkgInDmg"
    packageID="com.jamf.connect"
    appNewVersion=$(getJSONValue "$(curl -s "https://learn-be.jamf.com/api/bundlelist?name_filter.field=name&name_filter.value=jamf-connect-documentation-current")" ".bundle_list[0].title" | awk -F ' ' '{print $NF}')
    downloadURL="https://files.jamfconnect.com/JamfConnect.dmg"
    expectedTeamID="483DWKW443"
    ;;
