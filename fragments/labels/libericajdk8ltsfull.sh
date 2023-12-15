libericajdk8ltsfull)
    name="Liberica JDK 8 Full LTS"
    type="pkg"
    case $(arch) in
        "arm64")
            cpu_arch="arm"
        ;;
        "i386")
            cpu_arch="x86"
        ;;
    esac
    # Liberica lumps all versions in one GitHub repo but provide an API to query latest version details that we can parse
    latestVersionJSON=$(curl "https://api.bell-sw.com/v1/liberica/releases?version-modifier=latest&version-feature=8&bitness=64&release-type=lts&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full")
	# The release version of their JDK8 package (which are used in the download URLs) are formatted differently from the CFBundleVersion 1.8.0_382-b06 and 8u382+6 in pkg name
    pkgNewVersion="$(echo ${latestVersionJSON} | sed 's/.*"version":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    # We take the CFBundleIdentifier from the installed version (if found) and snag what they call the "Update Version"
    appCustomVersion(){ if [ -f "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" ] ; then /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/liberica-jdk-8-full.jdk/Contents/Info.plist" "CFBundleVersion" | sed -n 's:.*_\(.*\)\-.*:\1:p' ; fi }
    appNewVersion="$(echo ${latestVersionJSON} | sed 's/.*"updateVersion":"\{0,1\}\([^,"]*\)"\{0,1\}.*/\1/')"
    # As long as we have the latest PKG version, we can get a direct download URL without further JSON parsing
    downloadURL=$(curl "https://api.bell-sw.com/v1/liberica/releases?version=${pkgNewVersion}&bitness=64&os=macos&arch=${cpu_arch}&package-type=pkg&bundle-type=jdk-full&output=text&fields=downloadUrl")
	expectedTeamID="8LBATW8FZA"
    ;;
