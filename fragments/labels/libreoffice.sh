libreoffice)
    name="LibreOffice"
    type="dmg"
    appNewVersion="$(curl -s https://download.documentfoundation.org/libreoffice/stable/ | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | tail -1)"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/${appNewVersion}/mac/aarch64/LibreOffice_${appNewVersion}_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/${appNewVersion}/mac/x86_64/LibreOffice_${appNewVersion}_MacOS_x86-64.dmg"
    fi
    appCustomVersion(){ defaults read "/Applications/LibreOffice.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-3 }
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
