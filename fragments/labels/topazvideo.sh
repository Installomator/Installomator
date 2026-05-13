topazvideo|\
topazvideoai)
    name="Topaz Video AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'videoVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    downloadURL="https://topazlabs.com/d/tvai/latest/mac/full"
    archiveName="TopazVideoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
