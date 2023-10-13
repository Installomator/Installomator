chemdoodle|\
chemdoodle2d)
     name="ChemDoodle"
     type="dmg"
     downloadURL="https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | xmllint --html --format - 2>&1 | grep -e "ChemDoodle-macos" | sed -r 's/.*href="([^"]+).*/\1/g' | head -n1)"
     expectedTeamID="9XP397UW95"
     folderName="ChemDoodle"
     appName="${folderName}/ChemDoodle.app"
     appNewVersion=$(curl -s -L https://www.ichemlabs.com/download | xmllint --html --format - 2>&1 | grep -e "ChemDoodle-macos" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{0,2}' | head -n1)
     versionKey="CFBundleVersion"
     ;;
chemdoodle3d)
     name="ChemDoodle3D"
     type="dmg"
     downloadURL="https://www.ichemlabs.com$(curl -s -L https://www.ichemlabs.com/download | xmllint --html --format - 2>&1 | grep -e "ChemDoodle3D-macos" | sed -r 's/.*href="([^"]+).*/\1/g' | head -n1)"
     expectedTeamID="9XP397UW95"
     folderName="ChemDoodle3D"
     appName="${folderName}/ChemDoodle3D.app"
     appNewVersion=$(curl -s -L https://www.ichemlabs.com/download | xmllint --html --format - 2>&1 | grep -e "ChemDoodle3D-macos" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{0,2}' | head -n1)
     versionKey="CFBundleVersion"
     ;;
