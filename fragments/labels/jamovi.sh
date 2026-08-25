jamovi)
    name="jamovi"
    type="dmg"
    if [[ "$arch" == "arm64" ]]; then
        archSuffix="arm64"
    else
        archSuffix="x64"
    fi
    downloadFile=$(curl -fsL "https://dl.jamovi.org/" | grep -o "jamovi-[0-9][^\"]*-macos-${archSuffix}\.dmg" | sort -Vu | tail -n 1)
    downloadURL="https://dl.jamovi.org/${downloadFile}"
    appNewVersion="$(echo "$downloadFile" | sed -E "s/^jamovi-([0-9.]+)-macos-${archSuffix}\.dmg$/\1/")"
    expectedTeamID="9NCBP559AB"
    ;;
