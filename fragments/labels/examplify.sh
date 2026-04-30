examplify)
    name="Examplify"
    type="pkgInDmg"
    appNewVersion=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://support.examsoft.com/hc/en-us/articles/11146797283469-Examplify-Direct-Download-Links-for-Windows-and-Mac-Installers" | grep -o 'releases\.examsoft\.com/Examplify/[0-9.]*/' | head -1 | sed 's|releases\.examsoft\.com/Examplify/||; s|/||')
    if [[ $(arch) == "arm64" ]]; then
        # Apple Silicon (ARM64) version
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://support.examsoft.com/hc/en-us/articles/11146797283469-Examplify-Direct-Download-Links-for-Windows-and-Mac-Installers" | grep -o 'https://releases\.examsoft\.com/Examplify/[^"]*-arm64\.dmg' | head -1)
    else
        # Intel version (without -arm64 suffix)
        downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36" -fsL "https://support.examsoft.com/hc/en-us/articles/11146797283469-Examplify-Direct-Download-Links-for-Windows-and-Mac-Installers" | grep -o 'https://releases\.examsoft\.com/Examplify/[^"]*\.dmg' | grep -v 'arm64' | head -1)
    fi
    expectedTeamID="5P9D4ESR3W"
    blockingProcesses=("Examplify")
    ;;
