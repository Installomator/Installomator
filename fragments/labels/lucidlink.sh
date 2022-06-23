lucidlink)
    name="Lucid"
    type="pkg"
    downloadURL="https://www.lucidlink.com/download/latest/osx/stable/"
    appNewVersion="$(curl -s 'https://d3il9duqikhdqy.cloudfront.net/latest/osx/installer.json' | grep installerFile | cut -d- -f2 | cut -d. -f 1-3)"
    expectedTeamID="Y4KMJPU2B4"
    blockingProcesses=( "Lucid" "Lucid Helper" "Lucid Helper (GPU)" "Lucid Helper (Renderer)" )
    ;;
