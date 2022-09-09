libreoffice)
    name="LibreOffice"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        arch_type="aarch64"
    fi
    libreoffice_latest_version="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)"
    downloadURL="https://download.documentfoundation.org/libreoffice/stable/${libreoffice_latest_version}/mac/${arch_type:-x86_64}/LibreOffice_${libreoffice_latest_version}_MacOS_${arch_type:-x86-64}.dmg"
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)_.*/\1/g')
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
