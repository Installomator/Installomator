talkdeskcxcloud)
    name="Talkdesk"
    type="dmg"
    appNewVersion=$(curl -fs https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-latest-metadata.json | sed -n -e 's/^.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*$/\1/p' | head -n 1)
    downloadURL="https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-${appNewVersion}.dmg"
    expectedTeamID="YGGJX44TB8"
    ;;
