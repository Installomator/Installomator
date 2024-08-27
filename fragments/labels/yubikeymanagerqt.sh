yubikeymanagerqt)
    name="YubiKey Manager GUI"
    type="pkg"
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-latest-mac.pkg"
    appNewVersion=$(curl -fsIL "${downloadURL}" | grep -i "^location" | grep -Eo "[1-9][0-9\.]*" )
    expectedTeamID="LQA3CS5MM7"
    ;;
