asperaconnect)
    name="Aspera Connect"
    type="pkg"
    indexFilePath=$(curl -fsL https://ibmaspera.com/help/downloads/desktop | grep 'script type="module"' | grep -o "/.*.js")
    downloadBaseUrl="https:$(curl -fsL https://ibmaspera.com${indexFilePath} | grep versions.js | grep -o "var i=\"//.*downloads/connect" | sed -E 's/var i="//g')"
    appInfo=$(curl -fs ${downloadBaseUrl}/latest/versions.js | grep -o "{.*}")
    appNewVersion=$(echo ${appInfo} | jq -r '.entries.[] | select(.title == "Aspera Connect for macOS") | .version' | awk -F "." '{print$1"."$2"."$3}')
    downloadURL="${downloadBaseUrl}/latest/$(echo ${appInfo} | jq -r '.entries.[] | select(.title == "Aspera Connect for macOS").links.[] | select(.rel == "enclosure-one-click").href')"
    expectedTeamID="PETKK2G752"
    ;;
