dymoconnectdesktop)
    name="DYMO Connect"
    type="pkg"
    appNewVersion=$(curl -s https://formulae.brew.sh/cask/dymo-connect | grep -o 'Current version:.*[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+' | head -1)
    if [[ $(arch) == "arm64" ]]; then
        archiveName="DCDMac${appNewVersion}-Arm64.pkg"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="DCDMac${appNewVersion}-X64.pkg"
    fi
    downloadURL="https://dymoreleasecontent.blob.core.windows.net/dymo-release/DCDMAC/${archiveName}"
    expectedTeamID="N3S6676K3E"
    ;;
