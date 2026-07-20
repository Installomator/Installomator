guardlydata)
    name="GuardlyData"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        arch_dir="arm64"
        downloadURL="https://storage.googleapis.com/guardlydata-apps/arm64/GuardlyData.pkg"
    else
        arch_dir="x86_64"
        downloadURL="https://storage.googleapis.com/guardlydata-apps/x86_64/GuardlyData-Intel.pkg"
    fi
    appNewVersion=$(curl -fsL "https://storage.googleapis.com/guardlydata-apps/${arch_dir}/version.txt" 2>/dev/null)
    expectedTeamID="GMZ7XULHBM"
    ;;