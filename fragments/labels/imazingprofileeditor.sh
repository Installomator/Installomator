imazingprofileeditor)
    # Credit: Bilal Habib @Pro4TLZZ
    name="iMazing Profile Editor"
    type="dmg"
    downloadURL="https://downloads.imazing.com/mac/iMazing-Profile-Editor/iMazingProfileEditorMac.dmg"
    appNewVersion=$(curl -s https://imazing.com/profile-editor/download | grep -2 'Version' | head -4 | sed -nE 's/.*<b>([0-9\.]+)<\/b>.*/\1/p' )
    expectedTeamID="J5PR93692Y"
    ;;
