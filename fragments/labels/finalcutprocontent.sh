finalcutprocontent)
    name="FCPContent"
    type="pkgInDmg"
    downloadURL=$(curl -s "https://support.apple.com/en-us/106574" | grep -Eo 'https://updates\.cdn-apple\.com[^"]+FCPContent\.dmg' | head -n 1)
    packageID="com.apple.pkg.FCPContent"
    expectedTeamID="Software Update"
    ;;
