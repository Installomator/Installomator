magicbullet)
    name="Magic Bullet Suite"
    type="zip"
    appCustomVersion(){
    	ls "/Users/Shared/Red Giant/uninstall" | grep bullet | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | head -n 30 | sort -gru
    }
    for i in {1..5}; do
        appNewVersion=$(curl -H "User-Agent: Mozilla/5.0 (X11; Fedora; Linux x86_64; rv:129.0) Gecko/20100101 Firefox/129.0" -fs "https://support.maxon.net/hc/en-us/sections/13336955539228-Red-Giant" | grep -i "Magic Bullet" | grep -Eo "([0-9][0-9][0-9][0-9]\.[0-9]+(\.[0-9])?)" | sort -gru | head -n 1)
        if [[ -n $appNewVersion ]]; then break; else sleep 1; fi
    done
    if [[ "$appNewVersion" =~ ^[^.]*\.[^.]*$ ]]; then
        appNewVersion=$(sed 's/\([0-9]*\.[0-9]*\)/\1.0/' <<<"$appNewVersion")
    fi
    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/magicbullet/releases/$appNewVersion/MagicBulletSuite-${appNewVersion}_Mac.zip"
    magicbulletResponse=$(curl -s -I -L "$downloadURL")
    magicbulletHttpStatus=$(echo "$magicbulletResponse" | head -n 1 | cut -d ' ' -f 2)
    if [[ "$magicbulletHttpStatus" == "200" ]]; then
	    printlog "DownloadURL HTTP status code: $magicbulletHttpStatus" INFO
    elif [[ "$magicbulletHttpStatus" == "404" ]]; then
	    downloadURL="https://mx-app-blob-prod.maxon.net/mx-package-production/installer/macos/redgiant/magicbullet/releases/$appNewVersion/MagicBulletSuite-${appNewVersion}_mac.zip"
	    printlog "Had to change DownloadURL due HTTP Status." INFO
    else
	    printlog "Unexpected HTTP status code: $magicbulletHttpStatus" ERROR
    fi
    installerTool="Magic Bullet Suite Installer.app"
    CLIInstaller="Magic Bullet Suite Installer.app/Contents/Scripts/install.sh"
    CLIArguments=()
    expectedTeamID="4ZY22YGXQG"
    ;;
