apachenetbeans)
    name="Apache NetBeans"
    type="pkg"
    packageID="org.apache.netbeans"
    appNewVersion=$(curl -sfL "https://netbeans.apache.org/" | xmllint --html --format - 2>/dev/null | grep -A 1 "<div class=\"annotation\">Latest release</div>" | sed '2p;d' | sed 's/<h1>Apache NetBeans //g' | sed 's/<\/h1>//g' | xargs)
    downloadURL="https://archive.apache.org/dist/netbeans/netbeans-installers/${appNewVersion}/Apache-NetBeans-${appNewVersion}.pkg"
    expectedTeamID="2GLGAFWEQD"
    ;;
