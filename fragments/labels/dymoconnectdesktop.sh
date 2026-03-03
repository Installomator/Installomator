dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    appNewVersion=$(curl -s https://formulae.brew.sh/cask/dymo-connect | grep -o 'Current version:.*[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    archiveName="DCDMac${appNewVersion}.pkg"
    arch="Arm64"
    if [[ $(/usr/bin/arch) != "arm64" ]]; then
        arch="X64"
    fi
    downloadURL="https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDMAC/DCDMac${appNewVersion}-${arch}.pkg"
    expectedTeamID="N3S6676K3E"
    ;;
