camostudio)
    name="Camo Studio"
    type="zip"
    downloadURL="https://reincubate.com/res/labs/camo/camo-macos-latest.zip"
    #appNewVersion=$(curl -s -L  https://reincubate.com/support/camo/release-notes/ | grep -m2 "has-m-t-0" | head -1 | cut -d ">" -f2 | cut -d " " -f1)
    appNewVersion=$( curl -fs "https://uds.reincubate.com/release-notes/camo/" | head -1 | cut -d "," -f3 | grep -o -e "[0-9.]*" )
    # Camo Studio will ask for admin permissions to install som plug-ins. that has not been handled.
    expectedTeamID="Q248YREB53"
    ;;
