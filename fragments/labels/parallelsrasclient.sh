parallelsrasclient)
    name="Parallels Client"
    type="pkg"
    appMajorVersion=$(curl -sf "https://download.parallels.com/website_links/ras/index.json" | head -2 | tail -1 | tr -dc '[:alnum:]')
    downloadURL=$(curl -sf "https://download.parallels.com/website_links/ras/$appMajorVersion/builds-en_US.json" | grep '"Mac Client":' | head -1 | cut -d ":" -f2- | cut -d '"' -f2)
    appNewVersion=$(sed -E 's#.*/v[0-9]+/([0-9.]+)/RasClient.*#\1#g' <<< "$downloadURL" | sed -E 's/^([0-9]+)\.([0-9]+)\.[0-9]+\.(.*)$/\1.\2.\3/')
    expectedTeamID="4C6364ACXT"
    ;;
