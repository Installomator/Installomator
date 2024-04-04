yubikeymanagerqt)
    name="YubiKey Manager GUI"
    type="pkg"
    baseURL="https://developers.yubico.com/yubikey-manager-qt/Releases"
    downloadURL="$baseURL/$(curl -sfL "$baseURL" | grep -oE 'yubikey[^"]*.pkg' | head -1)"
    appNewVersion=$(grep -oE '\d+\.[0-9.]*\d' <<< "$downloadURL")
    expectedTeamID="LQA3CS5MM7"
    ;;
