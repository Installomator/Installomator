perimeter81|\
harmonysase)
    name="Harmony SASE"
    type="pkg"
    releaseNotesURL="https://sc1.checkpoint.com/documents/Infinity_Portal/WebAdminGuides/EN/SASE-Admin-Guide/Content/Topics-SASE-AG/Release-Notes/HS-Agent/MacOS.htm"
    version=$(curl -fsSL "$releaseNotesURL" | sed -nE 's/.*<h2><a name="([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)".*/\1/p' | head -1)
    pkgURL="Harmony_SASE_${version}.pkg"
    downloadURL="https://static.perimeter81.com/agents/mac/$pkgURL"
    appNewVersion="$version"
    expectedTeamID="924635PD62"
    ;;
