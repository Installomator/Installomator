citrixworkspace)
    #credit: Erik Stam (@erikstam) and #Philipp on MacAdmins Slack
    name="Citrix Workspace"
    type="pkgInDmg"
    downloadURL="https:"$(curl -s -L "https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html#ctx-dl-eula-external" | grep "dmg?" | sed "s/.*rel=.\(.*\)..id=.*/\1/") # http://downloads.citrix.com/18823/CitrixWorkspaceApp.dmg?__gda__=1605791892_edc6786a90eb5197fb226861a8e27aa8
    appNewVersion=$(curl -fs https://www.citrix.com/downloads/workspace-app/mac/workspace-app-for-mac-latest.html | grep "<p>Version" | head -1 | cut -d " " -f1 | cut -d ";" -f2 | cut -d "." -f 1-3)
    expectedTeamID="S272Y5R93J"
    ;;
