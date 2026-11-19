libreoffice)
    name="LibreOffice"
    type="dmg"
    libreOfficeDownloadVersion=$(curl -fsL "https://download.documentfoundation.org/libreoffice/stable/" | grep -oE "[0-9]+[.][0-9]+[.][0-9]+/" | tr -d / | awk -F. 'max=="" || ($1+0)*1000000+($2+0)*1000+($3+0) > max { max=($1+0)*1000000+($2+0)*1000+($3+0); version=$0 } END { print version }')
    appNewVersion=$(curl -fsL "https://download.documentfoundation.org/libreoffice/src/${libreOfficeDownloadVersion}/" | grep -oE "libreoffice-${libreOfficeDownloadVersion}[.][0-9]+[.]tar[.]xz" | sed -E "s/^libreoffice-//; s/[.]tar[.]xz$//" | head -1)
    if [[ $(arch) == "arm64" ]]; then
        downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/${appNewVersion}/mac/aarch64/LibreOffice_${appNewVersion}_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/${appNewVersion}/mac/x86_64/LibreOffice_${appNewVersion}_MacOS_x86-64.dmg"
    fi
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
