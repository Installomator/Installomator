jetbrains*|\
intellijideace|\
pycharmce)
    unset downloadURL name json appNewVersion expectedTeamID jbApp
    expectedTeamID="2ZEFAR8TH3"
    type="dmg"
    case ${label##jetbrains} in
        datagrip)       name="DataGrip"          ; jbApp="DG"  ;;
        pycharm)        name="PyCharm"           ; jbApp="PC"  ;;
        pycharmce)      name="PyCharm CE"        ; jbApp="PCC" ;;
        phpstorm)       name="PHPStorm"          ; jbApp="PS"  ;;
        intellijidea)   name="IntelliJ IDEA"     ; jbApp="II"  ;;
        intellijideace) name="IntelliJ IDEA CE"  ; jbApp="IIC" ;;
        clion)          name="CLion"             ; jbApp="CL"  ;;
        webstorm)       name="Webstorm"          ; jbApp="WS"  ;;
        rider)          name="Rider"             ; jbApp="RD"  ;;
        toolbox)        name="JetBrains Toolbox" ; jbApp="TBA" ;;
    esac
    if [[ $jbApp ]]; then
        json=$(curl -fs "https://data.services.jetbrains.com/products/releases?code=${jbApp}&latest=true&type=release")
        appNewVersion=$(print $json | egrep -o 'version.*?,' | cut -d '"' -f3)
        [[ $(arch) =~ arm* ]] && downloadURL=$(print $json | egrep -o 'macM1".*,' | cut -d \" -f5|head -1)
        [[ -z $downloadURL ]] && downloadURL=$(print $json | egrep -o 'mac".*,' | cut -d \" -f5|head -1)
    else
        printlog "unknown label matching jetbrains*"
        cleanupAndExit 99
    fi
    ;;
