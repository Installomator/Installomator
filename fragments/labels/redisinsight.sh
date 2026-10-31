redisinsight)
    name="Redis Insight"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="Redis-Insight-mac-arm64.dmg"
    else
        archiveName="Redis-Insight-mac-x64.dmg"
    fi
    downloadURL="$(downloadURLFromGit redis RedisInsight)"
    appNewVersion="$(versionFromGit redis RedisInsight)"
    expectedTeamID="UUK47G4BAZ"
    ;;
