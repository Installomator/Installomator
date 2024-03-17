filezilla)
    name="FileZilla"
    type="tbz"
    packageID="org.filezilla-project.filezilla"
    if [[ $(arch) == "arm64" ]]; then
        cpu_arch="arm64"
    elif [[ $(arch) == "i386" ]]; then
        cpu_arch="x86"
    fi
    downloadURL=$(curl -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '"' '{print $2}' )
    appNewVersion=$( curl -fsL https://filezilla-project.org/download.php\?show_all=1 | grep macos-$cpu_arch | head -n 1 | awk -F '_' '{print $2}' )
    expectedTeamID="5VPGKXL75N"
    blockingProcesses=( NONE )
    ;;

