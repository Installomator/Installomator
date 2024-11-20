
packages)
   #NOTE: Packages is signed but _not_ notarized, so spctl will reject it
   name="Packages"
   type="pkgInDmg"
   pkgName="Install Packages.pkg"
   downloadURL="http://s.sudre.free.fr/Software/files/Packages.dmg"
   appNewVersion="$(curl -s http://s.sudre.free.fr/Software/Packages/about.html | grep Version | sed -n 's/.*<td>\([0-9][0-9.]*\)<\/td>.*/\1/p')"
   expectedTeamID="NL5M9E394P"
   ;;
