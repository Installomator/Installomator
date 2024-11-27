nodejs)
    name="nodejs"
    type="pkg"
    appNewVersion=$(curl -s -L https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')
    appCustomVersion(){/usr/local/bin/node -v}
    downloadURL="https://nodejs.org/dist/latest/node-$(curl -s -L https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p').pkg"
    expectedTeamID="HX7739G8FX"
    ;;
