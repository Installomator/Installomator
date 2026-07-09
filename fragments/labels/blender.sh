blender)
    name="Blender"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    baseVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/ | grep -o 'Blender[0-9]\+\.[0-9]\+' | cut -d 'r' -f 2 | sort -V | tail -1)
    if [[ $(arch) == "arm64" ]]; then
        appNewVersion=$(curl -sf https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/ | grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-arm64\.dmg' | sort -V | tail -1 | sed -E 's/[^0-9]*([0-9]+\.[0-9]+\.[0-9]+).*/\1/' )
        archiveName=$(curl -sf "https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/"| grep -o 'blender-[0-9]\+\.[0-9]\+\.[0-9]\+-macos-arm64\.dmg' | sort -V | tail -1)
        downloadURL="https://ftp.nluug.nl/pub/graphics/blender/release/Blender$baseVersion/$archiveName"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://www.blender.org/download/release/Blender4.5/blender-4.5.11-macos-x64.dmg"
        printlog "Latest version of Blender for Intel is 4.5.11, which is no longer updated. Please consider upgrading to Apple Silicon."
    fi
    expectedTeamID="68UA947AUU"
    ;;
