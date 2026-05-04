jamovi)
    name="jamovi"
    type="dmg"
    baseURL="https://dl.jamovi.org"
    
    if [[ $(arch) == "arm64" ]]; then
    archSuffix="arm64"
    elif [[ $(arch) == "i386" ]]; then
    archSuffix="x64"
    else
    printlog "ERROR: Unsupported architecture $(arch) for jamovi label" ERROR
    exit 1
    fi
    if [[ -n $jamoviLatest ]]; then
    downloadFile=$(curl -sf "${baseURL}/" | grep -o "jamovi-2\.[7-9][^\"]*-macos-${archSuffix}\.dmg" | sort -V | tail -1)
    else
    downloadFile=$(curl -sf "${baseURL}/" | grep -o "jamovi-2\.6[^\"]*-macos-${archSuffix}\.dmg" | sort -V | tail -1)
    fi
    downloadURL="${baseURL}/${downloadFile}"
    appNewVersion="$(echo "$downloadFile" | cut -d '-' -f 2)"
