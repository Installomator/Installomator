soundly)
    name="Soundly"
    # From: https://getsoundly.com
    # Cheat Sheet: https://getsoundly.com/cheatsheet/Soundly-Cheatsheet-Mac.pdf
    type="dmg"
    if [[ $(arch) == i386 ]]; then
    downloadURL="https://storage.googleapis.com/soundlyapp/Soundly.dmg"
    elif [[ $(arch) == arm64 ]]; then
    downloadURL="https://storage.googleapis.com/soundlyapp/arm/Soundly.dmg"
    fi
    #appNewVersion=""
    expectedTeamID="67Y6N7VTDG"
    ;;
