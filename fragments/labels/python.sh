python)
    name="Python"
    type="pkg"
    appNewVersion="$( curl --compressed -s "https://www.python.org/downloads/macos/" | awk '/Latest Python 3 Release - Python/{gsub(/<\/?[^>]+(>|$)/, ""); print $NF}' )"
    archiveName="$( curl -s "https://www.python.org/ftp/python/$appNewVersion/" | grep -om 1 "\"python.*macos.*\.pkg\"" | tr -d \" )"
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    shortVersion=$( cut -d '.' -f1,2 <<< $appNewVersion )
    packageID="org.python.Python.PythonFramework-$shortVersion"
    expectedTeamID="BMM5U3QVKW"
    blockingProcesses=( "IDLE" "Python Launcher" )
    versionKey="CFBundleVersion"
    appCustomVersion() {
        if [ -d "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/" ]; then
            /usr/bin/defaults read "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info" CFBundleVersion
        fi
    }
    ;;
