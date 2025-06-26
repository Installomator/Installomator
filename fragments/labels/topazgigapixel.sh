topazgigapixel|\
topazgigapixelai)
    # credit: Tully Jagoe
    name="Topaz Gigapixel AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'gigaVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    versionKey="CFBundleShortVersionString"
    downloadURL="https://topazlabs.com/d/gigapixel/latest/mac/full"
    archiveName="TopazGigapixelAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
