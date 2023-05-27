jamovi)
    name="jamovi"
    type="dmg"
    downloadURL="http://www.jamovi.org"
    if [[ -n $jamoviLatest ]]; then
        downloadURL="${downloadURL}$(curl -s "$downloadURL/download.html" | grep macos | grep "download-button" | head -1 | cut -d '"' -f 4)"
    else
        downloadURL="${downloadURL}$(curl -s "$downloadURL/download.html" | grep macos | grep "download-button" | tail -1 | cut -d '"' -f 4)"
    fi
    # The above is a cheat, they list both the "Latest" version and the "Solid" version twice on the page, but in opposing order.
    #     I'm also assuming they mean Latest = beta, and Solid = Stable.
    appNewVersion="$(echo $downloadPATH | cut -d '-' -f 2)"
    expectedTeamID="9NCBP559AB"
    ;;
