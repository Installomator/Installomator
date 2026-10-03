cortexcode|snowflakecoco)
    name="Cortex Code"
    type="dmg"
    if [[ $(arch) == arm64 ]]; then
        downloadURL="https://sfc-repo.snowflakecomputing.com/coco-desktop/downloads/latest/Cortex-Code-darwin-arm64.dmg"
    elif [[ $(arch) == i386 ]]; then
        downloadURL="https://sfc-repo.snowflakecomputing.com/coco-desktop/downloads/latest/Cortex-Code-darwin-x64.dmg"
    fi
    appNewVersion=$(curl -fsL "https://sfc-repo.snowflakecomputing.com/coco-desktop/downloads/index.html" | grep -oE '>[0-9]+\.[0-9]+\.[0-9]+/<' | tr -d '></' | sort -t. -k1,1n -k2,2n -k3,3n | tail -1)
    expectedTeamID="W4NT6CRQ7U"
    ;;
