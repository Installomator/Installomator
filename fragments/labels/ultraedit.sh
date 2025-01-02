ultraedit)
    name="UltraEdit"
    type="dmg"
    downloadURL="https://downloads.ultraedit.com/main/ue/mac/UltraEdit.dmg"
    appNewVersion=$(plutil -p /Volumes/UltraEdit\ Setup/UltraEdit.app/Contents/Info.plist | grep CFBundleShortVersionString | awk -F'"' '{print $4}')
    expectedTeamID="2T4C9Y59FF"
    ;;
