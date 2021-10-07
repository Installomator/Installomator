cloudya)
    name="Cloudya"
    type="appInDmgInZip"
    downloadURL="$(curl -fs https://www.nfon.com/de/service/downloads | grep -E -o "https://cdn.cloudya.com/Cloudya-[.0-9]+-mac.zip")"
    appNewVersion="$(curl -fs https://www.nfon.com/de/service/downloads | grep -E -o "Cloudya Desktop App MAC [0-9.]*" | sed -E 's/.*Cloudya Desktop App MAC ([0-9.]*).*/\1/g')"
    expectedTeamID="X26F74J8TH"
    ;;
