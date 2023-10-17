resolumearena)
    name="Resolume Arena"
    appName="Resolume Arena/Arena.app"
    type="pkgInDmg"
    pkgName="Resolume Arena Installer.pkg"
    blockingProcesses=( "Arena" "Alley" "Wire" )
    downloadURL="https://$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_3) AppleWebKit/536.28.10 (KHTML, like Gecko) Version/6.0.3 Safari/536.28.10" -fs "https://resolume.com/download/?file=latest_arena" | xmllint --html --xpath "substring-after(string(//iframe/@src), '//')" - 2> /dev/null)"
    appNewVersion=$( echo "${downloadURL}" | grep -oE '[0-9]{1,2}_[0-9]{1,2}_[0-9]{1,2}' | sed 's/_/./g;' )
    expectedTeamID="Z9Y8N6Q4L8"
    ;;