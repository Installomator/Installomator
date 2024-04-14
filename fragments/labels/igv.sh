igv)
    name="IGV"
    type="zip"
    downloadURL="$(curl -fs "https://igv.org/doc/desktop/DownloadPage/" | grep -oE "https://data.broadinstitute.org/igv/projects/downloads/.*/IGV_MacApp_.*_WithJava\.zip")"
    appNewVersion="$(echo $downloadURL | sed -E 's/.*IGV_MacApp_([0-9]+(\.[0-9]+)*).*/\1/')"
    appName="${name}_${appNewVersion}.app"
    expectedTeamID="R787A9V6VV"
    ;;

