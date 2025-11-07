8x8)
    name="8x8 Work"
    type="dmg"
    downloadURL=$( \
      arch=$(uname -m); \
      curl -fsSL "https://support-portal.8x8.com/helpcenter/viewArticle.html?d=8bff4970-6fbf-4daf-842d-8ae9b533153d" | \
      if [[ "$arch" == "arm64" ]]; then \
        grep -oE 'https://work-desktop-assets\.8x8\.com[^"]*arm64[^"]*\.dmg' | head -n1; \
      else \
        grep -oE 'https://work-desktop-assets\.8x8\.com[^"]*\.dmg' | grep -v 'arm64' | head -n1; \
      fi \
    )
    appNewVersion=""
    expectedTeamID="FC967L3QRG"
    ;;
