gram)
     name="Gram Editor"
     type="dmg"
     appName="Gram.app"
     appNewVersion="$(curl -fsL "https://codeberg.org/GramEditor/gram/releases.rss" | xmllint --xpath 'string(//item/title)' -)"
     downloadURL="$([[ $(/usr/bin/arch) == "arm64" ]] && echo "https://codeberg.org/GramEditor/gram/releases/download/${appNewVersion}/Gram-aarch64-${appNewVersion}.dmg" || echo "https://ziranpub.b-cdn.net/Gram-x86_64-${appNewVersion}.dmg")"
     expectedTeamID="TQ3LTB39SU"
     blockingProcesses=( "gram" "Gram" )
;;
