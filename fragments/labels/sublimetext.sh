sublimetext)
    # credit: Søren Theilgaard (@theilgaard)
    name="Sublime Text"
    type="zip"
    downloadURL=downloadURL="$(curl -fs "https://www.sublimetext.com/download_thanks?target=mac#direct-downloads" | grep "mac.zip" | grep -o -i -E "https.*"| cut -d '"' -f1 | head -1)"
    appNewVersion=$(curl -fs https://www.sublimetext.com/download | grep -i -A 4 "id.*changelog" | grep -io "Build [0-9]*")
    expectedTeamID="Z6D26JE4Y4"
    ;;
