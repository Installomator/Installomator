logioptions|\
logitechoptions)
    name="Logi Options"
    type="pkgInZip"
    #downloadURL=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -oie "https.*/.*/options/.*\.zip" | head -1)
    downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/options/options_installer.zip"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr "," "\n" | grep -A 10 "macOS" | grep -B 5 -ie "https.*/.*/options/.*\.zip" | grep "Software Version" | sed 's/\\u[0-9a-z][0-9a-z][0-9a-z][0-9a-z]//g' | grep -ioe "Software Version.*[0-9.]*" | tr "/" "\n" | grep -oe "[0-9.]*" | head -1)
    #pkgName="LogiMgr Installer "*".app/Contents/Resources/LogiMgr.pkg"
    pkgName=LogiMgr.pkg
    expectedTeamID="QED4VVPZWA"
    ;;
