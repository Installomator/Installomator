mactexfull|mactex)
    name="MacTeX Full"
    appName="TeX Live Utility.app"
    type="pkg"
    downloadURL="https://mirror.ctan.org/systems/mac/mactex/MacTeX.pkg"
    appNewVersion=$(curl -sf "https://www.tug.org/mactex/downloading.html" | grep -o 'MacTeX-[0-9]\{4\}' | head -1 | grep -o '[0-9]\{4\}')
    appCustomVersion(){ find /usr/local/texlive -maxdepth 1 -type d -name '20[0-9][0-9]' 2>/dev/null | sed 's#.*/##' | sort -nr | head -n 1; }
    expectedTeamID="RBGCY5RJWM"
    ;;
