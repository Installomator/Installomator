libericajdk20full)
    name="Liberica JDK 20 Full"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="arm"
        ;;
        "i386")
            cpu_arch="x86"
        ;;
    esac
    appNewVersion="$(curl "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full" | sed 's/.*"version":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    downloadURL=$(curl "https://api.bell-sw.com/v1/liberica/releases?version=${appNewVersion}&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full&output=text&fields=downloadUrl")
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/liberica-jdk-20-full.jdk/Contents/Info.plist" ] ; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" "CFBundleVersion" ; fi }
    expectedTeamID="8LBATW8FZA"
    ;;
