island)
    name="Island"
    type="dmg"
    downloadURL="" # Customers MUST request a dedicated URL from the vendor to use this label. ie. https://your_tenant_id.internal.island.io/id_provided_by_vendor/stable/latest/mac/IslandX64.dmg
    appCustomVersion() { echo "$(defaults read /Applications/Island.app/Contents/Info.plist CFBundleShortVersionString | sed 's/[^.]*.//' | sed -e 's/*\.//')" }
    appNewVersion=$(curl -fsLIXGET ${downloadURL} | grep -i "^x-amz-meta-version" | sed -e 's/x-amz-meta-version\: //' | tr -d '\r')
    expectedTeamID="38ZC4T8AWY"
    ;;
