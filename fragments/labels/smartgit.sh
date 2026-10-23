smartgit)
    name="SmartGit"
    type="dmg"
    if [[ $(arch) == "arm64" ]]; then
        smartgitArch="arm64"
    else
        smartgitArch="x86_64"
    fi
    downloadURL=$(curl -fs "https://www.smartgit.dev/download/" | grep -o -E "https://download\.smartgit\.dev/smartgit/smartgit-[0-9_]+-macos-${smartgitArch}\.dmg" | sort -V | tail -1)
    appNewVersion=$(echo "$downloadURL" | sed -E 's/.*smartgit-([0-9_]+)-macos.*/\1/; s/_/./g')
    expectedTeamID="PHMY45PTNW"
    ;;
