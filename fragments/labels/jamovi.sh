jamovi)
    name="jamovi"
    type="dmg"
    baseURL="https://dl.jamovi.org"

    if [[ "$(arch)" == "arm64" ]]; then
        archSuffix="arm64"
    else
        archSuffix="x64"
    fi

    if [[ -n $jamoviLatest ]]; then
        # current = 2.7.x series (odd minor)
        downloadFile=$(curl -sf "${baseURL}/" \
            | grep -o "jamovi-2\.[7-9][^\"]*-macos-${archSuffix}\.dmg" \
            | sort -V | tail -1)
    else
        # solid = 2.6.x series (even minor)
        downloadFile=$(curl -sf "${baseURL}/" \
            | grep -o "jamovi-2\.6[^\"]*-macos-${archSuffix}\.dmg" \
            | sort -V | tail -1)
    fi

    downloadURL="${baseURL}/${downloadFile}"
    appNewVersion="$(echo "$downloadFile" | cut -d '-' -f 2)"
    expectedTeamID="9NCBP559AB"
    ;;
