python)
    name="Python"
    type="pkg"
    pageContent=$(curl -fsL --compressed "https://www.python.org/downloads/macos/")
    appNewVersion=$(echo "$pageContent" | grep -oE 'Latest Python 3 Release - Python [0-9]+\.[0-9]+\.[0-9]+' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)
    shortVersion=$(echo "$appNewVersion" | cut -d "." -f1,2)
    archiveName="python-${appNewVersion}-macos11.pkg"
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/$archiveName"
    appCustomVersion(){ /usr/bin/defaults read "/Library/Frameworks/Python.framework/Versions/$shortVersion/Resources/Python.app/Contents/Info" CFBundleVersion 2>/dev/null; }
    expectedTeamID="BMM5U3QVKW"
    blockingProcesses=( "IDLE" "Python Launcher" )
    ;;
