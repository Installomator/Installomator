logitechoptions)
    # credit: AP Orlebeke (@apizz)
    name="Logitech Options"
    type="pkgInZip"
    downloadURL=$(curl -fs -L https://www.logitech.com/en-us/product/options | grep -m 1 -o "https.*zip" | sed 's/\"//' | awk '{print $1}')
    #appNewVersion=$(curl -fs -L https://www.logitech.com/en-us/product/options | grep -m 1 -o "https.*zip" | sed 's/\"//' | awk '{print $1}' | sed -E 's/.*_([0-9\.]*)[-\.].*/\1/' )
    pkgName="LogiMgr Installer ${appNewVersion}.app/Contents/Resources/LogiMgr.pkg"
    expectedTeamID="QED4VVPZWA"
    ;;
