libreoffice)
    name="LibreOffice"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
    	releaseURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/aarch64/"
    	appNewVersion=$(curl -sf $releaseURL | grep -m 1 "_MacOS_aarch64.dmg" | sed "s|.*LibreOffice_\(.*\)_MacOS.*|\\1|")
        downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/aarch64/LibreOffice_"$appNewVersion"_MacOS_aarch64.dmg"
    elif [[ $(arch) == "i386" ]]; then
    	releaseURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/x86_64/"
    	appNewVersion=$(curl -sf $releaseURL | grep -m 1 "_MacOS_x86-64.dmg" | sed "s|.*LibreOffice_\(.*\)_MacOS.*|\\1|")
        downloadURL="https://downloadarchive.documentfoundation.org/libreoffice/old/latest/mac/x86_64/LibreOffice_"$appNewVersion"_MacOS_x86-64.dmg"
    fi
    expectedTeamID="7P5S3ZLCN7"
    blockingProcesses=( soffice )
    ;;
