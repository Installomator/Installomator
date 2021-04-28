microsoftautoupdate)
    name="Microsoft AutoUpdate"
    type="pkg"
    downloadURL="https://go.microsoft.com/fwlink/?linkid=830196"
    #appNewVersion=$(curl -fs https://macadmins.software/latest.xml | xpath '//latest/package[id="com.microsoft.autoupdate.standalone"]/cfbundleshortversionstring' 2>/dev/null | sed -E 's/<cfbundleshortversionstring>([0-9.]*)<.*/\1/')
    appNewVersion=$(curl -fsIL "$downloadURL" | grep -i location: | grep -o "Microsoft_AutoUpdate.*pkg" | sed -E 's/[a-zA-Z_]*_([0-9.]*)_.*/\1/g' | cut -d "." -f 1-2)
    expectedTeamID="UBF8T346G9"
    # commented the updatetool for MSAutoupdate, because when Autoupdate is really
    # old or broken, you want to force a new install
    #updateTool="/Library/Application Support/Microsoft/MAU2.0/Microsoft AutoUpdate.app/Contents/MacOS/msupdate"
    #updateToolArguments=( --install --apps MSau04 )
    ;;
