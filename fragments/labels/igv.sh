igv)
    name="IGV"
    type="zip"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="$(curl -fs "https://igv.org/doc/desktop/DownloadPage/" | grep -m1 -oE "https://data.broadinstitute.org/igv/projects/downloads/.*/IGV_MacApp_.*_WithJava\.zip")"
        appNewVersion="$(echo $downloadURL | sed -E 's/.*IGV_MacApp_([0-9]+(\.[0-9]+)*).*/\1/')"
    else
        downloadURL="$(curl -fs "https://igv.org/doc/desktop/DownloadPage/" | grep -m1 -oE "https://data.broadinstitute.org/igv/projects/downloads/.*/IGV_MacAppIntel_.*_WithJava\.zip")"
        appNewVersion="$(echo $downloadURL | sed -E 's/.*IGV_MacAppIntel_([0-9]+(\.[0-9]+)*).*/\1/')"
    fi
    appName="${name}_${appNewVersion}.app"
    expectedTeamID="R787A9V6VV"
    ;;

