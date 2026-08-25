python)
    name="Python"
    type="pkg"
    pageContent=$(curl -sL --compressed https://www.python.org/downloads/macos/)
    appNewVersion=$(echo "$pageContent" | grep -oE 'Latest Python 3 Release - Python [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    shortVersion=$(echo "$appNewVersion" | cut -d '.' -f1,2)
    archiveName="python-${appNewVersion}-macos11.pkg"
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    packageID="org.python.Python.PythonFramework-$shortVersion"
    expectedTeamID="BMM5U3QVKW"
    blockingProcesses=("IDLE" "Python Launcher")
    versionKey="CFBundleVersion"
    appCustomVersion() {
        frameworkPath="/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info"
        [[ -f "${frameworkPath}.plist" ]] && /usr/bin/defaults read "$frameworkPath" CFBundleVersion
    }
    ;;
