apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    appNewVersion=$( curl -fs "https://netbeans.apache.org/front/main/download/index.html" | grep -o 'Apache NetBeans [0-9]\+' | sed 's/Apache NetBeans //' | head -n 1 )
    downloadURL="https://dlcdn.apache.org/netbeans/netbeans-installers/"${appNewVersion}"/Apache-NetBeans-"${appNewVersion}".pkg"
    expectedTeamID="2GLGAFWEQD"
    ;;
