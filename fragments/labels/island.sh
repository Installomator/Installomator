island)
    name="Island"
    type="dmg"
    downloadURL="https://d3qqq7lqx3rf23.internal.island.io/E5QCaudFDx5FE5OX4INk/stable/latest/mac/IslandX64.dmg"
    appCustomVersion() { echo "$(defaults read /Applications/Island.app/Contents/Info.plist CFBundleShortVersionString | sed 's/[^.]*.//' | sed -e 's/*\.//')" }
    appNewVersion=$(curl -fsLIXGET "https://d3qqq7lqx3rf23.internal.island.io/E5QCaudFDx5FE5OX4INk/stable/latest/mac/IslandX64.dmg" | grep -i "^x-amz-meta-version" | sed -e 's/x-amz-meta-version\: //' | tr -d '\r')
    expectedTeamID="38ZC4T8AWY"
    ;;
