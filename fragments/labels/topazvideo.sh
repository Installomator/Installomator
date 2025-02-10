topazvideo|\
topazvideoai)
    name="Topaz Video AI"
    type="pkg"
    appNewVersion=$(curl -fs https://community.topazlabs.com/c/video-ai/video-ai-releases/69 | grep  -o "raw-topic-link'>.*<" | grep -o "v.*<" | sed -E 's/[v|<]//g' | head -1)
    downloadURL="https://downloads.topazlabs.com/deploy/TopazVideoAI/${appNewVersion}/TopazVideoAI-${appNewVersion}.pkg"
    archiveName="TopazVideoAI-${appNewVersion}.pkg"
    expectedTeamID="3G3JE37ZHF"
    ;;
