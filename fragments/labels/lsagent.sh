lsagent)
    name="LsAgent-osx"
    #Description: Lansweeper is an IT Asset Management solution. This label installs the latest version. 
    #Download: https://www.lansweeper.com/download/lsagent/
    # Needs to figure out how to send these arguments to the command
#Usage:
#  --help                                      Display the list of valid options
#  --version                                   Display product information
#  --unattendedmodeui <unattendedmodeui>       Unattended Mode UI
#                                              Default: none
#                                              Allowed: none minimal minimalWithDialogs
#  --optionfile <optionfile>                   Installation option file
#                                              Default: 
#  --debuglevel <debuglevel>                   Debug information level of verbosity
#                                              Default: 2
#                                              Allowed: 0 1 2 3 4
#  --mode <mode>                               Installation mode
#                                              Default: osx
#                                              Allowed: osx text unattended
#  --debugtrace <debugtrace>                   Debug filename
#                                              Default: 
#  --installer-language <installer-language>   Language selection
#                                              Default: en
#                                              Allowed: sq ar es_AR az eu pt_BR bg ca hr cs da nl en et fi fr de el he hu id it ja kk ko lv lt no fa pl pt ro ru sr zh_CN sk sl es sv th zh_TW tr tk uk va vi cy
#  --prefix <prefix>                           Installation Directory
#                                              Default: /Applications/LansweeperAgent
#  --server <server>                           FQDN, NetBios or IP of the Scanning Server
#                                              Default: 
#  --port <port>                               Listening Port on the Scanning Server
#                                              Default: 9524
#  --agentkey <agentkey>                       Cloud Relay Authentication Key (Optional)
#                                              Default: 

    type="dmg"
    downloadURL="https://content.lansweeper.com/lsagent-mac/"
    appNewVersion="$(curl -fsIL "$downloadURL" | grep -i "location" | cut -w -f2 | cut -d "/" -f5-6 | tr "/" ".")"
    installerTool="LsAgent-osx.app"
    CLIInstaller="LsAgent-osx.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=""
    expectedTeamID="65LX6K7CBA"
    ;;
