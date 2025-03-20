topazphoto|\
topazphotoai)
    name="Topaz Photo AI"
    type="pkg"
    appNewVersion=$(curl -fs https://www.topazlabs.com/downloads | grep  -o 'photoVersion = "v.*"' | grep -o ' "v.*"' | sed -E 's/[v|"| ]//g')
    downloadURL="https://topazlabs.com/d/photo/latest/mac/full"
    archiveName="TopazPhotoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
