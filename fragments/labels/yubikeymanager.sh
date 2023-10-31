yubikeymanager)
    # credit: Reuven Cohen
    name="YubiKey Manager"
    type="pkg"
    #downloadURL="https://github.com/Yubico/yubikey-manager/releases/download/5.0.1/yubikey-manager-5.0.1-mac.pkg"
	  downloadURL=$(downloadURLFromGit Yubico yubikey-manager)
    appNewVersion=$(versionFromGit Yubico yubikey-manager)
    expectedTeamID="LQA3CS5MM7"
    #CLI for YubikeyManager which is not installed via the QT version.
    ;;
