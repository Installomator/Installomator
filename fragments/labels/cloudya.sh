cloudya)
    name="Cloudya"
    type="appInDmgInZip"
    downloadURL="$(curl -fsL https://www.nfon.com/de/service/downloads | grep -i -E -o "https://cdn.cloudya.com/Cloudya-[.0-9]+-mac.zip")"
    appNewVersion="$(curl -fsL https://www.nfon.com/de/service/downloads | grep -i -E -o "Cloudya Desktop App MAC [0-9.]*" | sed 's/^.*\ \([^ ]\{0,7\}\)$/\1/g' | head -n1)"
    expectedTeamID="X26F74J8TH"
    ;;
