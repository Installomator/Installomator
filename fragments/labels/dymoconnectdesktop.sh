dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    appNewVersion=$(curl -s https://formulae.brew.sh/cask/dymo-connect | grep -o 'Current version:.*[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    archiveName="DCDMac${appNewVersion}.pkg"
    downloadURL="https://download.dymo.com/dymo/Software/Mac/DCDMac${appNewVersion}.pkg"
    expectedTeamID="N3S6676K3E"
    ;;
