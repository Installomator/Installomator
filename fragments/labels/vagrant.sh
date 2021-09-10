vagrant)
    # credit: AP Orlebeke (@apizz)
    name="Vagrant"
    type="pkgInDmg"
    pkgName="vagrant.pkg"
    downloadURL=$(curl -fs https://www.vagrantup.com/downloads | tr '><' '\n' | awk -F'"' '/x86_64.dmg/ {print $6}' | head -1)
    #appNewVersion=$( curl -fs https://www.vagrantup.com/downloads.html | grep -i "Current Version" )
    appNewVersion=$(versionFromGit hashicorp vagrant)
    expectedTeamID="D38WU7D763"
    ;;
