topazvideo|\
topazvideoai)
    name="Topaz Video AI"
    type="dmg"
    downloadURL="https://topazlabs.com/d/tvai/latest/mac/full"
    appNewVersion=$(curl -fsIL "$downloadURL" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1 | sed -E 's#.*/TopazVideoAI-([0-9]+(\.[0-9]+)+)\.dmg$#\1#')
    expectedTeamID="3G3JE37ZHF"
    ;;
    
