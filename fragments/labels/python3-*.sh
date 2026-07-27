python3-*)
    python3Series=${label//python3-/}
    name="Python 3.${python3Series}"
    type="pkg"
    appNewVersion="$( curl -s --compressed "https://www.python.org/downloads/macos/" | grep "python-3.$python3Series.*-macos11.pkg" | head -n 1 | cut -d'/' -f 6 )"
    archiveName="$( curl -s --compressed "https://www.python.org/ftp/python/$appNewVersion/" | grep -om 1 "\"python.*macos.*\.pkg\"" | tr -d \" )"
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    shortVersion=$( cut -d '.' -f1,2 <<< $appNewVersion )
    packageID="org.python.Python.PythonFramework-$shortVersion"
    if [[ $shortVersion == "3.11" ]] || [[ $shortVersion == "3.12" ]] || [[ $shortVersion == "3.13" ]]; then
    expectedTeamID="BMM5U3QVKW"
    elif [[ $shortVersion == "3.9" ]] || [[ $shortVersion == "3.10" ]]; then
    expectedTeamID="DJ3H93M7VJ"
    fi
    blockingProcesses=( "IDLE" "Python Launcher" )
    versionKey="CFBundleVersion"
    appCustomVersion() {
        if [ -d "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/" ]; then
            /usr/bin/defaults read "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info" CFBundleVersion
        fi
    }
    ;;
