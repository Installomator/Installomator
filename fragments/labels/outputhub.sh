outputhub)
    name="Output Hub"
    type="dmg"
    ymlContent=$(curl -fsL "https://release-builds.outputaudio.com/output-hub/latest-mac.yml" | tr -d '\r')
    dmgName=$(echo "$ymlContent" | sed -n 's/^[[:space:]]*-[[:space:]]*url:[[:space:]]*\(.*\.dmg\)[[:space:]]*$/\1/p' | head -n 1)
    if [[ $dmgName =~ -([0-9.]+)-mac ]]; then
        appNewVersion=$match[1]
    fi
    dmgNameEncoded=${dmgName// /%20}
    downloadURL="https://release-builds.outputaudio.com/output-hub/${dmgNameEncoded}"
    versionKey="CFBundleVersion"
    expectedTeamID="M4BQRFQ23V"
    ;;
