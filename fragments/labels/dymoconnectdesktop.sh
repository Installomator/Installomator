dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    appNewVersion=$(curl -s https://formulae.brew.sh/cask/dymo-connect | grep -o 'Current version:.*[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    archiveName="DCDMac${appNewVersion}.pkg"
    if [[ $(/usr/bin/arch) == "arm64" ]]; then
        downloadURL="https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDMAC/DCDMac${appNewVersion}-Arm64.pkg"
     else
        downloadURL="https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDMAC/DCDMac${appNewVersion}-X64.pkg"
     fi
    expectedTeamID="N3S6676K3E"
    ;;
