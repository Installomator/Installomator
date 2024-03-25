bravepkg)
    name="Brave Browser"
    type="pkg"
    downloadURL="https://referrals.brave.com/latest/Brave-Browser.pkg" # Universal
        # https://referrals.brave.com/latest/Brave-Browser-arm64.pkg - ARM64
    appNewVersion="$(curl -fsL "https://updates.bravesoftware.com/sparkle/Brave-Browser/stable/appcast.xml" | xpath '//rss/channel/item[last()]/enclosure/@sparkle:version' 2>/dev/null  | cut -d '"' -f 2)"
    versionKey="CFBundleVersion"
    expectedTeamID="KL8N8XSYF4"
    ;;
