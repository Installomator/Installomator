topazphoto|\
topazphotoai)
    name="Topaz Photo AI"
    type="pkg"
    appNewVersion=$(curl -fs https://community.topazlabs.com/c/photo-ai/photo-ai-releases/85 | grep  -o "raw-topic-link'>.*<" | grep -o "v.*<" | sed -E 's/[v|<]//g' | head -1)
    downloadURL="https://downloads.topazlabs.com/deploy/TopazPhotoAI/${appNewVersion}/TopazPhotoAI-${appNewVersion}.pkg"
    archiveName="TopazPhotoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;

