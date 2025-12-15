antigravity)
name="Antigravity"
type="dmg"
indexFilePath=$(curl -fsL --compressed "https://antigravity.google/download" \
        | grep -Eo 'main-[0-9A-Za-z]+\.js' | head -1)
mainJS=$(curl -fsL --compressed "https://antigravity.google/${indexFilePath}")
if [[ "$(arch)" == "arm64" ]]; then
    downloadURL=$(echo "$mainJS" \
            | grep -Eo 'https://edgedl\.me\.gvt1\.com/edgedl/release2/[^"]+/antigravity/stable/[^"]+/darwin-arm/Antigravity\.dmg' \
            | head -1)
else
     downloadURL=$(echo "$mainJS" \
            | grep -Eo 'https://edgedl\.me\.gvt1\.com/edgedl/release2/[^"]+/antigravity/stable/[^"]+/darwin-x64/Antigravity\.dmg' \
            | head -1)
fi
appNewVersion=$(echo "$downloadURL" | sed -nE 's#.*/stable/([0-9.]+)-[0-9]+/darwin-.*#\1#p')
expectedTeamID="EQHXZ8M8AV"
;;
