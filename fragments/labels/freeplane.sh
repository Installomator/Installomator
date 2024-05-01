freeplane)
    name="Freeplane"
    type="dmg"
    appNewVersion=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive" | xpath '//rss/channel/item[1]/title' 2>/dev/null | awk -F'/' '{ print $(NF-2) }')
    if [[ $(arch) == "arm64" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive/${appNewVersion}" | grep -oE '<link>(.*-apple.dmg/download)</link>' | tail -1 | sed 's/<link>//;s/<\/link>//')
    elif [[ $(arch) == "i386" ]]; then
        downloadURL=$(curl -fsL "https://sourceforge.net/projects/freeplane/rss?path=/freeplane%20stable/archive/${appNewVersion}" | grep -oE '<link>(.*-intel.dmg/download)</link>' | tail -1 | sed 's/<link>//;s/<\/link>//')
    fi
    expectedTeamID="CSHVD99Y7K"
    ;;
