amadeuspro2)
    name="Amadeus Pro"
    type="zip"
    osVersion=$(sw_vers -productVersion | cut -d '.' -f 1)
    if (( osVersion >= 13 )); then
        printlog "Amadeus Pro 2 supports macOS 12 and earlier; use a separate Amadeus Pro 3 label on macOS 13 or later." ERROR
        cleanupAndExit 95 "Amadeus Pro 2 is not supported on this macOS version" ERROR
    fi
    amadeusPro2Page=$(curl -fsL "https://www.hairersoft.com/pro.html")
    downloadURL=$(printf '%s\n' "$amadeusPro2Page" | sed -nE 's|.*href="(https://s3\.amazonaws\.com/AmadeusPro2/AmadeusPro_([0-9]+(\.[0-9]+)+)\.zip)".*|\1|p' | head -1)
    appNewVersion=$(printf '%s\n' "$downloadURL" | sed -nE 's|.*/AmadeusPro_([0-9]+(\.[0-9]+)+)\.zip|\1|p')
    expectedTeamID="FWDH9W45C2"
    ;;
