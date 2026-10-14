androidfiletransfer)
    name="Android File Transfer"
    type="dmg"
    downloadURL="https://dl.google.com/dl/androidjumper/mtp/current/AndroidFileTransfer.dmg"
    appNewVersion=$(curl -fsIL "$downloadURL" | tr -d '\r' | sed -nE 's|^[Ll]ocation: .*/mtp/([0-9]{3})([0-9]{4})/.*|1.0.\1.\2|p' | tail -n 1)
    versionKey="CFBundleVersion"
    expectedTeamID="EQHXZ8M8AV"
    ;;
