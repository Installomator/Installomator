resolumearena)
    name="Resolume Arena"
    appName="Resolume Arena/Arena.app"
    type="pkgInDmg"
    pkgName="Resolume Arena Installer.pkg"
    blockingProcesses=( "Arena" "Alley" "Wire" )
    downloadURL="$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) ..." -fs "https://resolume.com/download/?file=latest_arena" \
    | grep -E -o "https:\/\/resolume\.com\/download\/file\?file=Resolume_Arena.*_Installer\.dmg" \
    | head -1 \
    | xargs -I {} curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) ..." -fs {} \
    | grep -E -o 'src="\/\/[^"]*\.dmg"' \
    | head -1 \
    | sed -E 's/src="(\/\/.*\.dmg)"/https:\1/')"
    appNewVersion=$( echo "${downloadURL}" | grep -oE '[0-9]{1,2}_[0-9]{1,2}_[0-9]{1,2}' | sed 's/_/./g;' )
    expectedTeamID="Z9Y8N6Q4L8"
    ;;