talkdeskcxcloud)
    name="Talkdesk"
    type="dmg"
    talkdeskcxcloudVersions=$(curl -fs "https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-latest-metadata.json")
    appNewVersion=$(getJSONValue "$talkdeskcxcloudVersions" "[0].version")
    downloadURL="https://td-infra-prd-us-east-1-s3-atlaselectron.s3.amazonaws.com/talkdesk-${appNewVersion}.dmg"
    expectedTeamID="YGGJX44TB8"
    ;;
