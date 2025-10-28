anydesk)
    name="AnyDesk"
    type="dmg"
    downloadURL="https://download.anydesk.com/anydesk.dmg"
    appNewVersion="$(curl -fs https://anydesk.com/en/downloads/mac-os | grep -i "d-block" | grep -E -o ">v[0-9.]* .*MB" | sed -E 's/.*v([0-9.]*) .*/\1/g')"
    expectedTeamID="KHRWM533LU"
    ;;
