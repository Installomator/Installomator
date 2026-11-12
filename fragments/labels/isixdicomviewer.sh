isixdicomviewer)
    name="IsiX DICOM Viewer"
    type="zip"
    appNewVersion="$(versionFromGit ThalesMMS IsiX-DICOM-Viewer-macOS)"
    if [[ $(arch) == "arm64" ]]; then
        archiveName="IsiX-DICOM-Viewer-${appNewVersion}-Apple-Silicon-Macs.zip"
    elif [[ $(arch) == "i386" ]]; then
        archiveName="IsiX-DICOM-Viewer-${appNewVersion}-Intel-Macs.zip"
    fi
    downloadURL="$(downloadURLFromGit ThalesMMS IsiX-DICOM-Viewer-macOS)"
    expectedTeamID="H4Q6WN7NV5"
    ;;
