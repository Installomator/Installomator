antconc)
    name="AntConc"
    type="dmg"
    appNewVersion=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://www.laurenceanthony.net/software/antconc/" | grep -oE '\([0-9]+\.[0-9]+\.[0-9]+\)' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | sort -rV | head -n 1)
    if [[ $(arch) == "arm64" ]]; then
        # Apple Silicon (ARM64) version
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://www.laurenceanthony.net/software/antconc/" | grep -o 'software/antconc/releases/AntConc[0-9]*/apple-silicon/AntConc\.dmg' | head -1 | sed 's|^|https://www.laurenceanthony.net/|')
    else
        # Intel version
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://www.laurenceanthony.net/software/antconc/" | grep -o 'software/antconc/releases/AntConc[0-9]*/apple-intel/AntConc\.dmg' | head -1 | sed 's|^|https://www.laurenceanthony.net/|')
    fi
    expectedTeamID="28C42U4N5U"
    ;;
