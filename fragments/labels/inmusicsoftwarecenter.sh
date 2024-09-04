inmusicsoftwarecenter)
    name="inMusic Software Center"
    type="zip"
    appNewVersion="$(curl -fs https://imb-software-center.s3.amazonaws.com/release/darwin/version.json | grep currentRelease | cut -d: -f2 | cut -d\" -f2 | xargs)"
    downloadURL="https://inmusic.to/ISCMAC"
    expectedTeamID="NDEA34327T"
    ;;
