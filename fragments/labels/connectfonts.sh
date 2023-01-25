connectfonts)
name="Connect Fonts"
type="dmg"
downloadURL="https://links.extensis.com/connect_fonts/cf_latest?language=en&platform=mac"
appNewVersion=$( curl -fs "https://www.extensis.com/support/connect-fonts" | grep version: | head -n 1 | cut -c 104-109 )
expectedTeamID="J6MMHGD9D6"
;;
