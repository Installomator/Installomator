mactexbasic)
    name="MacTeX Basic"
    type="pkg"
    downloadURL="https://mirror.ctan.org/systems/mac/mactex/BasicTeX.pkg"
    appNewVersion=$(curl -sf "https://www.tug.org/mactex/downloading.html" | grep -o 'MacTeX-[0-9]\{4\}' | head -1 | grep -o '[0-9]\{4\}')
    packageID="org.tug.mactex.basictex${appNewVersion}"
    expectedTeamID="RBGCY5RJWM"
    ;;
