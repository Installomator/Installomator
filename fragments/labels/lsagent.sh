lsagent)
    name="LsAgent-osx"
    #Description: Lansweeper is an IT Asset Management solution. This label installs the latest version. 
    #Download: https://www.lansweeper.com/download/lsagent/
    type="dmg"
    downloadURL="https://content.lansweeper.com/lsagent-mac/"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "location" | cut -w -f2 | cut -d "/" -f5-6 | tr "/" ".")"
    installerTool="LsAgent-osx.app"
    CLIInstaller="LsAgent-osx.app/Contents/MacOS/installbuilder.sh"
    expectedTeamID="65LX6K7CBA"
    ;;
