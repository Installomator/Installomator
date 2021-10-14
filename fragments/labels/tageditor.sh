tageditor)
     name="Tag Editor"
     type="dmg"
     downloadURL="https://amvidia.com/downloads/tag-editor-mac.dmg"
     appNewVersion=curl -sf "https://amvidia.com/tag-editor" | grep -o -E '"softwareVersion":.'"{8}" | sed 's/\"//g' | awk -F ': ' '{print $2}'
     expectedTeamID="F2TH9XX9CJ"
     ;;
