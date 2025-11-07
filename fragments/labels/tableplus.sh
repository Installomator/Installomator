tableplus)
    name="TablePlus"
    type="dmg"
    downloadURL="https://tableplus.com/release/osx/tableplus_latest"
    appNewVersion=$(curl -fs https://tableplus.com/release/osx/tableplus_latest | grep -oE '[0-9]+/[^"]*TablePlus\.dmg' | grep -oE '^[0-9]+')
    versionKey="CFBundleVersion"
    expectedTeamID="3X57WP8E8V"
    ;;
    
