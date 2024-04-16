vimcal)
    name="Vimcal"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+-arm64\.dmg' | head -n 1)
        downloadURL="https://vimcal-m1.s3.us-west-1.amazonaws.com/$appNewVersion"
    elif [[ $(arch) == "i386" ]]; then
        appNewVersionL=$(curl -s https://www.vimcal.com/downloads/mac | grep -o 'Vimcal-[0-9.]\+\.dmg' | head -n 1)
        downloadURL="https://vimcal-production.s3.us-west-1.amazonaws.com/$appNewVersion"
    fi
    expectedTeamID="7F7GXK9J99"
    ;;