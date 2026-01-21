mamp)
    name="MAMP PRO"
    type="pkg"
    if [[ $(arch) != "i386" ]]; then
        printlog "Architecture: arm64 (not i386)"
        downloadURL="$(curl -fsL 'https://www.mamp.info/en/downloads/' | grep -o 'https://downloads.mamp.info/MAMP-PRO/macOS/MAMP-PRO/MAMP-MAMP-PRO-[^"]*Apple-chip.pkg' | head -1)"
    else
        printlog "Architecture: i386"
        downloadURL="$(curl -fsL 'https://www.mamp.info/en/downloads/' | grep -o 'https://downloads.mamp.info/MAMP-PRO/macOS/MAMP-PRO/MAMP-MAMP-PRO-[^"]*Intel-x86.pkg' | head -1)"
    fi
    appNewVersion="$(echo "${downloadURL}" | grep -o 'MAMP-MAMP-PRO-[0-9]*\.[0-9]*' | sed 's/MAMP-MAMP-PRO-//')"
    expectedTeamID="5KCB5KHK77"
    ;;
