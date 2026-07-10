yubikeymanagerqt)
    name="YubiKey Manager GUI"
    appName="YubiKey Manager.app"
    type="pkg"
    downloadURL=$(curl -fsL "https://developers.yubico.com/yubikey-manager-qt/Releases/" | grep -oE "yubikey-manager-qt-[0-9][^\"]*-mac\.pkg" | head -1 | sed 's|^|https://developers.yubico.com/yubikey-manager-qt/Releases/|')
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/yubikey-manager-qt-([^-]+)-mac\.pkg$|\1|')
    expectedTeamID="LQA3CS5MM7"
    blockingProcesses=( "YubiKey Manager" )
    ;;
