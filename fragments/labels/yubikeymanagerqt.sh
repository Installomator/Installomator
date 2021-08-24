yubikeymanagerqt)
    # credit: Tadayuki Onishi (@kenchan0130)
    name="YubiKey Manager GUI"
    type="pkg"
    downloadURL="https://developers.yubico.com/yubikey-manager-qt/Releases/$(curl -sfL https://api.github.com/repos/Yubico/yubikey-manager-qt/releases/latest | awk -F '"' '/"tag_name"/ { print $4 }')-mac.pkg"
    #appNewVersion=$(curl -fs https://developers.yubico.com/yubikey-manager-qt/Releases/ | grep mac.pkg | head -1 | sed -E "s/.*-([0-9.]*)-mac.*/\1/") # does not work
    appNewVersion=$(versionFromGit Yubico yubikey-manager-qt)
    expectedTeamID="LQA3CS5MM7"
    ;;
