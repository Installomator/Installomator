libreoffice)
    name="LibreOffice"
    type="dmg"
    appNewVersion="$(curl -Ls https://www.libreoffice.org/download/download-libreoffice/ | xmllint --html --xpath 'string(//p[@class="version_heading"])' - 2>/dev/null | xargs)"
    if [[ $(arch) == "arm64" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/${appNewVersion}/mac/aarch64/LibreOffice_${appNewVersion}_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	downloadURL="https://download.documentfoundation.org/libreoffice/stable/${appNewVersion}/mac/x86_64/LibreOffice_${appNewVersion}_MacOS_x86-64.dmg"
    fi
    appCustomVersion(){ defaults read "/Applications/LibreOffice.app/Contents/Info.plist" CFBundleVersion | cut -d '.' -f 1-3 }
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
