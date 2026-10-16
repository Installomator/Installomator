jamovi)
    name="jamovi"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        archSuffix="arm64"
    else
        archSuffix="x64"
    fi
    downloadFile=$(curl -fsSL -e "https://www.jamovi.org/" "https://www.jamovi.org/download.html" | grep -o "jamovi-[0-9][^\"]*-macos-${archSuffix}\.dmg" | sort -Vu | tail -n 1)
    downloadURL="https://www.jamovi.org/downloads/$downloadFile"
    appNewVersion=$(echo "$downloadFile" | sed -nE "s/^jamovi-([0-9.]+)-macos-${archSuffix}\.dmg$/\1/p")
    curlOptions=( -e "https://www.jamovi.org/download.html" )
    expectedTeamID="9NCBP559AB"
    ;;
