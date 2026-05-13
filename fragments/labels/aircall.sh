aircall)
    name="Aircall"
    type="zip"
    aircallUpdate=$(curl -fsL "https://electron.aircall.io/update/osx/1.0.0?channel=stable")
    downloadURL=$(echo "${aircallUpdate}" | sed -n 's/.*"url":"\([^"]*\)".*/\1/p')
    appNewVersion=$(echo "${aircallUpdate}" | sed -n 's/.*"name":"\([^"]*\)".*/\1/p')
    expectedTeamID="3ML357Q795"
    ;;
