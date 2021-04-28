docker)
    # credit: @securitygeneration
    name="Docker"
    type="dmg"
    #downloadURL="https://download.docker.com/mac/stable/Docker.dmg"
    if [[ $(arch) == arm64 ]]; then
     downloadURL="https://desktop.docker.com/mac/stable/arm64/Docker.dmg"
    elif [[ $(arch) == i386 ]]; then
     downloadURL="https://desktop.docker.com/mac/stable/amd64/Docker.dmg"
    fi
    appNewVersion=$(curl -ifs https://docs.docker.com/docker-for-mac/release-notes/ | grep ">Docker Desktop Community" | head -1 | sed -n -e 's/^.*Community //p' | cut -d '<' -f1)
    expectedTeamID="9BNSXJN65R"
    ;;
