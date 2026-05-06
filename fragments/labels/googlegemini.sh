googlegemini)
    name="Gemini"
    type="dmg"

    # Pull current DMG link from the official landing page so release tokens can change safely
    downloadURL=$(curl -fsL "https://gemini.google/mac" | sed -nE 's/.*href="(https:\/\/dl\.google\.com\/release2\/[^"]+\/release\/Gemini\.dmg)".*/\1/p' | head -n 1)

    # Google does not expose an obvious public version feed for this app yet.
    # Use Last-Modified as a change marker.
    appNewVersion=$(curl -fsIL "$downloadURL" | awk 'BEGIN{IGNORECASE=1} /^last-modified:/ {sub("\r","",$0); sub(/^[^:]+:[[:space:]]*/,"",$0); print; exit}')

    expectedTeamID="EQHXZ8M8AV"
    ;;
