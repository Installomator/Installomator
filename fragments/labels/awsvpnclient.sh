awsvpnclient)
    name="AWS VPN Client"
    type="pkg"
    packageID="com.amazon.awsvpnclient"
    appNewVersion=$(curl -fsL "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-macos-release-notes.md" | grep -m 1 -E '^\|[[:space:]]*[0-9]+[.][0-9]+[.][0-9]+[[:space:]]*\|' | awk -F '|' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $2); print $2}')
    if [[ "$(arch)" == "arm64" ]]; then
        archName="ARM64"
    else
        archName="x64"
    fi
    downloadURL=$(curl -fsL "https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-macos-release-notes.md" | grep -oE '\[Download macOS (ARM64|x64) version [0-9]+[.][0-9]+[.][0-9]+ ?\]\(https://[^)]*[.]pkg\)' | awk -v version="$appNewVersion" -v archName="$archName" '$0 ~ "Download macOS " archName " version " version {sub(/^.*\]\(/, ""); sub(/\)$/, ""); print; exit}')
    expectedTeamID="94KV3E626L"
    ;;
