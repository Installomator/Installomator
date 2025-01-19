vimcal)
    name="Vimcal"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        fileDownloadName=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+-arm64\.dmg' | head -n 1)
        appNewVersion="${fileDownloadName#Vimcal-}"
        appNewVersion="${appNewVersion%-arm64.dmg}"
        downloadURL="https://vimcal-m1.s3.us-west-1.amazonaws.com/$fileDownloadName"
    elif [[ $(arch) == "i386" ]]; then
        fileDownloadName=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+\.dmg' | head -n 1)
        appNewVersion="${fileDownloadName#Vimcal-}"
        appNewVersion="${appNewVersion%.dmg}"
        downloadURL="https://vimcal-production.s3.us-west-1.amazonaws.com/$fileDownloadName"
    fi
    expectedTeamID="7F7GXK9J99"
    ;;
