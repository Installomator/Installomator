perimeter81|\
harmonysase)
    name="Harmony SASE"
    #name="Perimeter 81"
    type="pkg"
    pkgURL=$(curl -sL https://support.perimeter81.com/docs/downloading-the-agent | grep -o 'Harmony[^"]*.pkg')
    downloadURL="https://static.perimeter81.com/agents/mac/$pkgURL"
    appNewVersion="$(curl -fsIL "${downloadURL}" | grep -i ^x-amz-meta-version | sed -E 's/x-amz-meta-version: //' | cut -d"." -f1-3)"
    expectedTeamID="924635PD62"
    ;;
