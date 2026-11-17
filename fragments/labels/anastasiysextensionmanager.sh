anastasiysextensionmanager)
    name="ExtensionManager"
    type="zip"
    downloadURL="https://f000.backblazeb2.com/file/anastasiy-downloads/EM/ExtensionManager.zip"
    appNewVersion=$(curl -fs "https://anastasiy.com/checkupdates.sp.xml?product=ExtensionManager" | xpath 'string(/rss/channel/item[last()]/enclosure/@*[local-name()="shortVersionString"])')
    expectedTeamID="D3SBBNFWTC"
    ;;
