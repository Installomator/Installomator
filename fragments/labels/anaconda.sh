anaconda)
    name="Anaconda-Navigator"
    packageID="com.anaconda.io"
    type="pkg"
    if [[ "$(arch)" == "arm64" ]]; then
        archiveName=$( curl -sf https://repo.anaconda.com/archive/ | awk '/href=".*Anaconda.*MacOSX.*arm64.*\.pkg"/{gsub(/.*href="|".*/, ""); gsub(/.*\//, ""); print; exit}' )
    else
        archiveName=$( curl -sf https://repo.anaconda.com/archive/ | awk '/href=".*Anaconda.*MacOSX.*x86_64.*\.pkg"/{gsub(/.*href="|".*/, ""); gsub(/.*\//, ""); print; exit}' )
    fi
    downloadURL="https://repo.anaconda.com/archive/$archiveName"
    appNewVersion=$( awk -F'-' '{print $2}' <<< "$archiveName" )
    expectedTeamID="Z5788K4JT7"
    blockingProcesses=( "Anaconda-Navigator.app" )
    appCustomVersion() {
        if [ -e "/Users/$currentUser/opt/anaconda3/bin/conda" ]; then
            "/Users/$currentUser/opt/anaconda3/bin/conda" list -f ^anaconda$ | awk '/anaconda /{print $2}'
        fi
    }
    updateTool="/Users/$currentUser/opt/anaconda3/bin/conda"
    updateToolArguments=( install -y anaconda=$appNewVersion )
    updateToolRunAsCurrentUser=1
    ;;
