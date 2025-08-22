filezilla)
    name="FileZilla"
    type="bz2"
    packageID="org.filezilla-project.filezilla"
    if [[ $(arch) == "arm64" ]]; then
        cpu_arch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        cpu_arch="x86"
    fi
    downloadURL=$(curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15" -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '"' '{print $2}' )
    appNewVersion=$( curl -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/13.1 Safari/605.1.15" -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '_' '{print $2}' )
    expectedTeamID="5VPGKXL75N"
    blockingProcesses=( NONE )
    ;;
    
