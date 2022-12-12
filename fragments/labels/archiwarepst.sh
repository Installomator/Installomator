archiwarepst)
    name="P5"
    type="pkgInDmg"
    packageID="com.archiware.presstore"
    appNewVersion=$(curl -sf https://www.archiware.com/download-p5 | grep -m 1 "ARCHIWARE P5 Version" | sed "s|.*Version \(.*\) -.*|\\1|")
    downloadURL=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo https://p5-downloads.s3.amazonaws.com/awpst"$appNrVersion"-darwin.dmg)
    pkgName=$(appNrVersion=`sed 's/[^0-9]//g' <<< $appNewVersion` && echo P5-"$appNrVersion"-Install.pkg)
    expectedTeamID="5H5EU6F965"
    # blockingProcesses=( nsd )
    ;;
