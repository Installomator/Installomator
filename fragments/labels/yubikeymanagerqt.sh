yubikeymanagerqt)
    name="YubiKey Manager"
    type="pkg"
    releaseData=$(curl -fsL "https://developers.yubico.com/yubikey-manager-qt/Releases/atom.xml")
    downloadURL=$(echo "$releaseData" | grep -oE 'https://developers\.yubico\.com/yubikey-manager-qt/Releases/yubikey-manager-qt-[0-9][^"]*-mac\.pkg' | head -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*/yubikey-manager-qt-([^-]+)-mac\.pkg$|\1|')
    expectedTeamID="LQA3CS5MM7"
    blockingProcesses=( "ykman-gui" )
    ;;
