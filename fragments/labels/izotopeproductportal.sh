izotopeproductportal)
    name="iZotope Product Portal"
    type="dmg"
    izotopeDetails="$(curl -fs 'https://productportal.izotope.com/api/productupdate' -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 14_6_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.72 ProductPortal/1.4.8/b28/macOS-x86_64 Safari/537.36')"
    appNewVersion=$(getJSONValue "${izotopeDetails}" "[0].Version")
    downloadURL=$(getJSONValue "${izotopeDetails}" "[0].OSXDownloadURL")
    installerTool="Install Product Portal.app"
    CLIInstaller="Install Product Portal.app/Contents/MacOS/installbuilder.sh"
    CLIArguments=( --mode unattended --disable-components launch_after_install )
    expectedTeamID="QGULMAPEB2"
    ;;
