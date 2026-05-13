packages)
    name="Packages"
    type="pkgInDmg"
    pkgName="Install Packages.pkg"
    appNewVersion=$(curl -fsL http://s.sudre.free.fr/Software/Packages/release_notes.html | grep "<b>Version</b>" | grep -oE "[0-9].*[0-9]")
    downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
    expectedTeamID="NL5M9E394P"
   ;;
