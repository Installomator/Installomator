krita)
    name="krita"
    type="dmg"
    downloadURL=$(curl -fs "https://krita.org/en/download/" | grep -oE "https:\/\/download\.kde\.org\/stable\/krita\/[0-9.]+/krita-[0-9.].*\.dmg" | head -1)
    appNewVersion=$(echo "${downloadURL}" | awk -F '/' '{ print $(NF-1) }')
    expectedTeamID="DL93766A3G" # temporary team id (https://krita-artists.org/t/code-signature-changed/95187/6)
    #expectedTeamID="5433B4KXM8"
    ;;
