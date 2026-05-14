logitune)
    name="Logi Tune"
    type="pkg"
    downloadURL="https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.pkg"
    appNewVersion=$(curl -fs "https://support.logi.com/api/v2/help_center/en-us/articles.json?label_names=webcontent=productdownload,webos=mac-macos-x-11.0" | tr '}' '\n' | grep "Logi Tune" | grep -o "Software Version: <\/span><\/b>[0-9.]*" | grep -oE "[0-9.]+" | head -1)
    expectedTeamID="QED4VVPZWA"
    ;;
