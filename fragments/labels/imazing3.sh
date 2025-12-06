imazing3)
    name="iMazing"
    type="dmg"
    downloadURL="https://downloads.imazing.com/mac/iMazing/iMazing3forMac.dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sL https://imazing.com/download | awk '/Version:/{getline; gsub(/[^0-9.]/,""); if($0!=""){print; exit}}')
    expectedTeamID="J5PR93692Y"
    ;;

