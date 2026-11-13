rive)
name="Rive"
type="dmg"
downloadURL="https://releases.rive.app/macos/latest/Rive.dmg"
appNewVersion=$(curl -fs "https://releases.rive.app/release.xml" | sed -nE 's/.*sparkle:shortVersionString="([^"]+)".*/\1/p' | head -1)
expectedTeamID="XXXXXXXXXX"
;;
