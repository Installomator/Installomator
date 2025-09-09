lucidlink)
    name="Lucid"
    # https://www.lucidlink.com/download
    type="pkg"
    downloadURL="https://www.lucidlink.com/download/latest/osx/stable/"
    appNewVersion=$( curl -fsIL "${downloadURL}" | grep -i "^location" | awk '{print $2}' | sed -E 's/.*\/[a-zA-Z]*-([0-9.]*)\..*/\1/g' | tail -n 1 )
    expectedTeamID="Y4KMJPU2B4"
    ;;
