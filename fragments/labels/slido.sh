slido)
    name="Slido"
    type="dmg"
    downloadURL=$(curl -fsIL "https://www.slido.com/api/download?application=powerpoint-mac" | awk 'BEGIN{IGNORECASE=1}/^location:/{gsub("\r",""); print $2}' | tail -n 1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's|.*_r([0-9]+)\.dmg$|\1|')
    versionKey="CFBundleVersion"
    expectedTeamID="44X73QA89R"
    ;;
