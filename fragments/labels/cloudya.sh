cloudya)
    name="Cloudya"
    type="appInDmgInZip"
    downloadURL="$(curl -fs https://www.nfon.com/de/service/downloads | grep -i -E -o "https://cdn.cloudya.com/Cloudya-[.0-9]+-mac.zip")"
    appNewVersion="$(curl -fs https://www.nfon.com/de/service/downloads | grep -i -E -o "Cloudya Desktop App MAC [0-9.]*" | sed 's/^.*\ \([^ ]\{0,7\}\)$/\1/g')"
    expectedTeamID="X26F74J8TH"
    ;;
