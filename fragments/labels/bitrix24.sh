bitrix24)
     name="Bitrix24"
     type="dmg"
     archiveName="bitrix24_desktop.dmg"
     downloadURL="https://dl.bitrix24.com/b24/bitrix24_desktop.dmg"
     appNewVersion="$(curl -fs "https://www.bitrix24.com/osx_version.php" | xpath 'string(//rss/channel/item/title)' 2>/dev/null)"
     expectedTeamID="5B3T3A994N"
     ;;
