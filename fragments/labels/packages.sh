packages)
   name="Packages"
   type="pkgInDmg"
   pkgName="Install Packages.pkg"
   downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
   appNewVersion=$(curl -fs "http://s.sudre.free.fr/Software/Packages/release_notes.html" | grep "Release_notes_Version" | head -1 | grep -Eo "\d+.\d+.\d+")
   expectedTeamID="NL5M9E394P"
   ;;
