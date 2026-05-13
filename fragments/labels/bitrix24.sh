bitrix24)
     name="Bitrix24"
     type="dmg"
     archiveName="bitrix24_desktop.dmg"
     if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://dl.bitrix24.com/b24/bitrix24_desktop_arm.dmg"
        appNewVersion=""
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://dl.bitrix24.com/b24/bitrix24_desktop.dmg"
    fi
     appNewVersion="$(curl -fs "https://www.bitrix24.com/osx_version.php" | xpath 'string(//rss/channel/item/title)' 2>/dev/null)"
     expectedTeamID="5B3T3A994N"
     ;;
