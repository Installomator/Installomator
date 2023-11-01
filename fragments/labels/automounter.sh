automounter)
    name="AutoMounter"
    type="dmg"
    downloadURL="https://www.pixeleyes.co.nz/automounter/AutoMounter.dmg"
    appNewVersion="$( curl -fs https://www.pixeleyes.co.nz/automounter/version )"
    versionKey="CFBundleShortVersionString"
    appName="$name.app"
    archiveName="$name.$type"
    blockingProcesses=( $name )
    expectedTeamID="UKWABN4MGL"
    ;;
