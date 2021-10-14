boxdrive)
    # credit: Isaac Ordonez, Mann consulting (@mannconsulting)
    name="Box"
    type="pkg"
    if [[ $(arch) == "arm64" ]]; then
        #Note: https://support.box.com/hc/en-us/articles/1500004479962-Box-Drive-support-on-devices-with-M1-chips
        downloadURL="https://e3.boxcdn.net/desktop/pre-releases/mac/BoxDrive.2.20.140-M1-beta.pkg"
    elif [[ $(arch) == "i386" ]]; then
        downloadURL="https://e3.boxcdn.net/box-installers/desktop/releases/mac/Box.pkg"
    fi
    expectedTeamID="M683GB7CPW"
    ;;
