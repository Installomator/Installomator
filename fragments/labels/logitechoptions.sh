logitechoptions)
    name="Logitech Options"
    type="pkgInZip"
    downloadURL=$(curl -fs https://support.logi.com/api/v2/help_center/en-us/articles.json | tr "," "\n" | grep -A 10 "macOS" | grep -oie "https.*/.*/options.*\.zip")
    appNewVersion=$(curl -fs https://support.logi.com/api/v2/help_center/en-us/articles.json | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/options.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    pkgName="LogiMgr Installer [0-9.]*.app/Contents/Resources/LogiMgr.pkg"
    expectedTeamID="QED4VVPZWA"
    ;;
