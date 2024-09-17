topazgigapixel|\
topazgigapixelai)
    # credit: @tully_jagoe
    name="Topaz Gigapixel AI"
    type="pkg"
    appNewVersion=$(curl -sSL "https://formulae.brew.sh/api/cask/topaz-gigapixel-ai.json" | awk -F'"version":' '{split($2, a, "\""); print a[2]}' | grep -oE '[0-9.]+')
    versionKey="CFBundleShortVersionString"
    downloadURL="https://downloads.topazlabs.com/deploy/TopazGigapixelAI/${appNewVersion}/TopazGigapixelAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
