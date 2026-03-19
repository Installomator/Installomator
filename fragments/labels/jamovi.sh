jamovi)
    name="jamovi"
    type="dmg"
    baseURL="https://www.jamovi.org"

    # Detect architecture for separate arm64/x64 DMGs
    if [[ "$(arch)" == "arm64" ]]; then
        archSuffix="arm64"
    else
        archSuffix="x64"
    fi

    # solid (stable) is listed first, current (latest) is listed second
    if [[ -n $jamoviLatest ]]; then
        downloadPath=$(curl -sf "${baseURL}/download.html" \
            | grep -o "/downloads/jamovi-[^\"]*-macos-${archSuffix}\.dmg" \
            | tail -1)
    else
        downloadPath=$(curl -sf "${baseURL}/download.html" \
            | grep -o "/downloads/jamovi-[^\"]*-macos-${archSuffix}\.dmg" \
            | head -1)
    fi

    downloadURL="${baseURL}${downloadPath}"
    appNewVersion="$(echo "$downloadPath" | cut -d '-' -f 2)"
    expectedTeamID="9NCBP559AB"
    ;;
