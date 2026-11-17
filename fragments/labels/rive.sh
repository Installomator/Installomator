rive)
name="Rive"
type="dmg"
riveFeed=$(curl -fsL "https://releases.rive.app/release.xml")
downloadURL=$(echo "$riveFeed" | xpath '(//rss/channel/item/enclosure/@url)[1]' 2>/dev/null | cut -d '"' -f2)
appNewVersion=$(echo "$riveFeed" | xpath '(//rss/channel/item/enclosure/@sparkle:shortVersionString)[1]' 2>/dev/null | cut -d '"' -f2)
expectedTeamID="NJ3JMFUNS9"
;;
