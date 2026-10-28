anytype)
    name="Anytype"
    type="dmg"

    releaseJSON=$(curl -fsL "https://api.github.com/repos/anyproto/anytype-ts/releases")

    # Anytype publishes alpha and beta releases without setting the GitHub
    # prerelease flag. As a result, prerelease==false cannot be relied upon
    # to identify production releases. Production releases consistently use
    # the format vX.Y.Z, while pre-release builds use suffixes such as
    # -alpha and -beta. We therefore match only semantic version tags.

    latestRelease=$(echo "$releaseJSON" | jq -c '
        .[] |
        select(.draft == false) |
        select(.tag_name | test("^v[0-9]+\\.[0-9]+\\.[0-9]+$"))
    ' | head -1)

    appNewVersion=$(echo "$latestRelease" | jq -r '.tag_name' | sed 's/^v//')

    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(echo "$latestRelease" | jq -r '
            .assets[] |
            select(.name | endswith("-mac-arm64.dmg")) |
            .browser_download_url
        ')
    else
        downloadURL=$(echo "$latestRelease" | jq -r '
            .assets[] |
            select(.name | endswith("-mac-x64.dmg")) |
            .browser_download_url
        ')
    fi

    expectedTeamID="J3NXTX3T5S"
    ;;
