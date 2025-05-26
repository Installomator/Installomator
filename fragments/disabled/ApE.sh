ape)
    name="ApE"
    type="dmg"
    downloadURL="https://jorgensen.biology.utah.edu/wayned/ape/Download/Mac/ApE_OSX_modern_current.dmg"
    appNewVersion="$(curl -fsL "https://jorgensen.biology.utah.edu/wayned/ape/" | grep -Eo 'ApE \(v[0-9]+\.[0-9]+\.[0-9]+' | sed -E 's/ApE \(v//')"
    expectedTeamID="F5459JB4SG"
    appName="ApE.app"
    blockingProcesses=( "ApE" )
    ;;
