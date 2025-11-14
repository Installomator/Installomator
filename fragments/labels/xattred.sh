xattred)
    # xattred lets you inspect and edit all extended attributes
    name="xattred"
    type="zip"
    folderName="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'xattred[0-9]*\.zip' | sort -V | tail -n 1 | sed -E 's/xattred([0-9]+)\.zip/xattred\1/')"
    appName="${folderName}/xattred.app"
    downloadURL="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'href="[^"]*xattred[0-9]*\.zip"' | sed 's/href="//;s/"//' | sort -V | tail -n 1)"
    appNewVersion="$(curl -fs https://eclecticlight.co/downloads/ | grep -o 'xattred [0-9]\+\(\.[0-9]\+\)\? (' | sed -E 's/xattred ([0-9]+(\.[0-9]+)?).*/\1/' | sort -V | tail -n 1)"
    expectedTeamID="QWY4LRW926"
    ;;
