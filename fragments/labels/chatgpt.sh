chatgpt)
	 # ChatGPT Mac client developed by OpenAI for general users offers an intuitive platform for accessing AI-powered assistance and support on macOS devices
    name="ChatGPT"
    type="dmg"
    downloadURL="https://persistent.oaistatic.com/sidekick/public/ChatGPT_Desktop_public_latest.dmg"
    appNewVersion="$(curl -fs "https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml" | xmllint --xpath 'string(//rss/channel/item/title[1])' -)"
    expectedTeamID="2DC432GLL2"
    ;;