libreoffice)
    name="LibreOffice"
    type="dmg"
    appMajorVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appMajorVersion"/mac/aarch64/LibreOffice_"$appMajorVersion"_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/"$appMajorVersion"/mac/x86_64/LibreOffice_"$appMajorVersion"_MacOS_x86-64.dmg"
    fi
    appNewVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | grep -m 1 ".tar.xz" | sed "s|.*libreoffice-\(.*\).tar.xz?.*|\\1|")"
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
