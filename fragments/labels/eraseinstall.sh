eraseinstall)
    name="EraseInstall"
    type="pkg"
    downloadURL=https://bitbucket.org$(curl -fs https://bitbucket.org/prowarehouse-nl/erase-install/downloads/ | grep pkg | cut -d'"' -f2 | head -n 1)
    expectedTeamID="R55HK5K86Y"
    ;;
