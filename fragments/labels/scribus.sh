scribus)
    name="Scribus"
    type="dmg"
    appNewVersion=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus" | xpath '//rss/channel/item[1]/title' 2>/dev/null | awk -F'/' '{ print $3 }')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus/${appNewVersion}" | grep -oE '<link>(.*-arm64.dmg/download)</link>' | head -1 |  sed 's/<link>//;s/<\/link>//')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/scribus/rss?path=/scribus/${appNewVersion}" | grep -oE '<link>(.*\.dmg/download)</link>' | grep -v '\-arm64' | head -1 | sed 's/<link>//;s/<\/link>//')
    fi
    expectedTeamID="627FV4LMG7"
    ;;
