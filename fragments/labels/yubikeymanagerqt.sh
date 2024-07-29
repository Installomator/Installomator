yubikeymanagerqt)
    name="YubiKey Manager GUI"
    type="pkg"
    appNewVersion=$(curl -fs https://developers.yubico.com/yubikey-manager-qt/Releases/ | grep mac.pkg | head -1 | sed -E "s/.*-([0-9.]*)-mac.*/\1/")
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/yubikey-manager-qt-$appNewVersion-mac.pkg"
    expectedTeamID="LQA3CS5MM7"
    ;;
