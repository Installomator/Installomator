logitune)
    name="Logi Tune"
    type="dmg"
    downloadURL="https://software.vc.logitech.com/downloads/tune/LogiTuneInstaller.dmg"
    appNewVersion=$(curl -fs "https://sw-update.vcc.logitech.com/downloads/tune/mac/logitune_mac_version.txt" | grep -oE "[0-9.]+" | head -1)
    expectedTeamID="QED4VVPZWA"
    appName="LogiTuneInstaller.app"
    CLIInstaller="LogiTuneInstaller.app/Contents/MacOS/LogiTuneInstaller"
    CLIArguments=(--silent)
    ;;
