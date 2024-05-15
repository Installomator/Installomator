vagrant)
    name="Vagrant"
    type="pkgInDmg"
    pkgName="vagrant.pkg"
    cpu_arch="${$(arch)/i386/amd64}"
    downloadURL=$(curl -fsL "https://developer.hashicorp.com/vagrant/downloads" | grep -oE 'https[^"]*'$cpu_arch'[^"]*.dmg' | head -1)
    appNewVersion=$( echo $downloadURL | cut -d "/" -f5 )
    expectedTeamID="D38WU7D763"
    ;;
