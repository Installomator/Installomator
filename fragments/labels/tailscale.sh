tailscale)
    name="Tailscale"
    type="zip"
    appNewVersion="$(curl -s https://pkgs.tailscale.com/stable/ | awk -F- '/Tailscale.*macos.zip/ {print $2}')"
    downloadURL="https://pkgs.tailscale.com/stable/Tailscale-${appNewVersion}-macos.zip"
    expectedTeamID="W5364U7YZB"
    versionKey="CFBundleShortVersionString"
    ;;
