logitechoptionsplusoffline)
    name="Logi Options+"
    appName="logioptionsplus.app"
    archiveName="logioptionsplus_installer_offline.zip"
    installerTool="logioptionsplus_installer_offline.app"
    type="zip"
    downloadURL="https://download01.logi.com/web/ftp/pub/techsupport/optionsplus/logioptionsplus_installer_offline.zip"
    # No reliable version source exists for the offline package specifically —
    # the Logi support API only reflects the online installer's version, which
    # is usually ahead of what's bundled in the offline zip. Leaving appNewVersion unset
    CLIInstaller="logioptionsplus_installer_offline.app/Contents/MacOS/logioptionsplus_installer"
    CLIArguments=(--quiet)
    expectedTeamID="QED4VVPZWA"
    versionKey="CFBundleVersion"
    ;;
