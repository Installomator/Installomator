guardlydata)
    # A local DLP desktop agent
    name="GuardlyData"
    type="pkg"
    packageID="com.selstan.GuardlyData"
    if [[ $(arch) == arm64 ]]; then
        arch_dir="arm64"
    else
        arch_dir="x86_64"
    fi
    downloadURL="https://storage.googleapis.com/guardlydata-apps/${arch_dir}/GuardlyData.pkg"
    appNewVersion=$(curl -fsL "https://storage.googleapis.com/guardlydata-apps/${arch_dir}/version.txt" 2>/dev/null)
    expectedTeamID="GMZ7XULHBM"
    blockingProcesses=(NONE)
    ;;