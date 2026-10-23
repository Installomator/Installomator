focusritecontrol2)
    name="Focusrite Control 2"
    type="dmg"
    appNewVersion=$(curl -fsL "https://releases.focusrite.com/com.focusrite.focusrite-control/release/focusrite-control.release.mac.xml" | xmllint --xpath 'string((//*[local-name()="enclosure"]/@*[local-name()="version"])[1])' -)
    downloadURL=$(curl -fsL "https://releases.focusrite.com/com.focusrite.focusrite-control/release/focusrite-control.release.mac.xml" | xmllint --xpath 'string((//*[local-name()="enclosure"]/@url)[1])' -)
    expectedTeamID="7VYBQV3T2Q"
;;
