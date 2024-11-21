chatgpt)
    name="ChatGPT"
    type="dmg"
    downloadURL="https://persistent.oaistatic.com/sidekick/public/ChatGPT.dmg"
    appNewVersion=""$(curl -fs  https://persistent.oaistatic.com/sidekick/public/sparkle_public_appcast.xml | grep shortVersionString | head -n 1 | sed -e 's/<[^>]*>//g' | awk '{print $1}')""
    expectedTeamID="2DC432GLL2"
    ;;
