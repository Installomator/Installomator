minstaller)
    name="mInstaller"
    type="zip"
    downloadURL=$(curl -fsL https://s3.motionvfx.com/mvfxpublic/mInstaller/sparkle/appcast.xml | grep -oE 'url="[^"]+/mInstaller-[0-9.]+\.zip"' | head -1 | cut -d'"' -f2)
    appNewVersion=$(echo "${downloadURL}" | sed -E 's/.*mInstaller-([0-9.]+)\.zip/\1/')
    expectedTeamID="MVBHMUPK33"
    blockingProcesses=( "mInstaller" )
    ;;
