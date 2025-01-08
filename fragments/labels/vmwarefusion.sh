vmwarefusion)
    name="VMware Fusion"
    type="zip"
    appNewVersion=$(curl -sfL https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/ | grep -o '<li><a href="[^"]*' | sed 's|<li><a href="||' | awk -F/ '{print $1}' | grep -E '[0-9]' | sort -V | tail -n 1)
    release=$(curl -sfL "https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/${appNewVersion}" | grep -o '<li><a href="[^"]*' | sed 's|<li><a href="||' | awk -F/ '{print $1}' | tail -n 1)
    tempZipDir=$(mktemp -d)
    curl -sfL https://softwareupdate.vmware.com/cds/vmw-desktop/fusion/${appNewVersion}/${release}/universal/core/com.vmware.fusion.zip.tar | tar -xz -C "${tempZipDir}"
    downloadURL="file://${tempZipDir}/com.vmware.fusion.zip"
    appName="payload/VMware Fusion.app"
    expectedTeamID="EG7KH642X6"
    ;;
