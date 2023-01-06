imageoptim)
    name="imageoptim"
    type="tbz"
    packageID="net.pornel.ImageOptim"
    downloadURL="https://imageoptim.com/ImageOptim.tbz2"
    appNewVersion=$( curl -fsL https://imageoptim.com/appcast.xml | grep "title" | tail -n 1 | sed 's/[^0-9.]//g' )
    expectedTeamID="59KZTZA4XR"
    blockingProcesses=( NONE )
    ;;
