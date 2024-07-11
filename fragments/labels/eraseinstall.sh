eraseinstall)
    name="erase-install"
    type="pkg"
    downloadURL=$(downloadURLFromGit grahampugh erase-install)
    appNewVersion=$(versionFromGit grahampugh erase-install)
    expectedTeamID="Software Update"
    appCustomVersion() { grep -i "version=" /Library/Management/erase-install/erase-install.sh | cut -d '"' -f2 }
    ;;
