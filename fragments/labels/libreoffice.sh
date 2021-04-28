libreoffice)
    # credit: Micah Lee (@micahflee)
    name="LibreOffice"
    type="dmg"
    downloadURL="https://download.documentfoundation.org/libreoffice/stable/$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)/mac/x86_64/LibreOffice_$(curl -s https://www.libreoffice.org/download/download/ | grep dl_version_number | head -n 1 | cut -d'>' -f3 | cut -d'<' -f1)_MacOS_x86-64.dmg"
    appNewVersion=$( echo "${downloadURL}" | sed -E 's/.*\/[a-zA-Z]*_([0-9.]*)_.*/\1/g' )
    expectedTeamID="7P5S3ZLCN7"
    ;;
