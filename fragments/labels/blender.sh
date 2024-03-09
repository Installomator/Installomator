blender)
    name="Blender"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    appNewVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/ | grep -o 'Blender[0-9]\+\.[0-9]\+' | cut -d 'r' -f 2 | sort -V | tail -1)
    if [[ $(arch) == "arm64" ]]; then
        archiveName=$(curl -sf "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$appNewVersion/"| grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-arm64\.dmg' | sort -V | tail -1)
        downloadURL="https://ftp.nluug.nl/pub/graphics/blender/release/Blender$appNewVersion/$archiveName"
    elif [[ $(arch) == "i386" ]]; then
        archiveName=$(curl -sf "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$appNewVersion/" | grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-x64\.dmg' | sort -V | tail -1)
        downloadURL="https://ftp.nluug.nl/pub/graphics/blender/release/Blender$appNewVersion/$archiveName"
    fi
    expectedTeamID="68UA947AUU"
    ;;
