daskeyboardq)
    name="Das Keyboard Q"
    type="pkg"
    downloadURL=$(curl -fs https://www.daskeyboard.io/get-started/software/ | awk -F\" '/pkg/ {print $2}')
    appNewVersion=$(curl -fs https://www.daskeyboard.io/get-started/software/ | grep pkg | cut -d / -f 5)
    expectedTeamID="ZY3RC4RUP6"
    blockingProcesses=( "Das Keyboard Q" )
    ;;