python)
    name="Python"
    type="pkg"
    appNewVersion="$( curl -s "https://www.python.org/downloads/macos/" | awk '/Latest Python 3 Release - Python/{gsub(/<\/?[^>]+(>|$)/, ""); print $NF}' )"
    archiveName=$( curl -s "https://www.python.org/ftp/python/$appNewVersion/" | awk '/href=".*python.*macos.*\.pkg"/{gsub(/.*href="|".*/, ""); gsub(/.*\//, ""); print}' )
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    shortVersion=$( cut -d '.' -f1,2 <<< $appNewVersion )
    packageID="org.python.Python.PythonFramework-$shortVersion"
    expectedTeamID="DJ3H93M7VJ"
    blockingProcesses=( "IDLE" "Python Launcher" )
    versionKey="CFBundleVersion"
    appCustomVersion() {
        if [ -d "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/" ]; then
            /usr/bin/defaults read "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info" CFBundleVersion
        fi
    }
    ;;
