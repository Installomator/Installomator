ringcentralapp)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="RingCentral"
    appNewVersion=$(curl -fs https://support.ringcentral.com/gb/en/release-notes/ringex/desktop.html | grep -i -m1 "<div>Version" | sed 's/[^0-9\.]//g')
    appCustomVersion() { defaults read /Applications/RingCentral.app/Contents/Info.plist CFBundleShortVersionString  | cut -c-7 }
    type="pkg"
    if [[ $(arch) != "i386" ]]; then
        downloadURL="https://app.ringcentral.com/download/RingCentral-arm64.pkg"
    else
        downloadURL="https://app.ringcentral.com/download/RingCentral.pkg"
    fi
    expectedTeamID="M932RC5J66"
    ;;
