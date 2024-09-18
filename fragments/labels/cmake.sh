cmake)
    name="CMake"
    type="dmg"
    appNewVersion=$(curl -fsL "https://cmake.org/download" | awk -F'[()]' '/id="latest"/{print $2}')
    downloadURL="https://github.com/Kitware/CMake/releases/download/v${appNewVersion}/cmake-${appNewVersion}-macos-universal.dmg"
    expectedTeamID="W38PE5Y733"
    ;;
