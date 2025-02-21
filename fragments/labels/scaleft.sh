scaleft)
    name="ScaleFT"
    type="pkg"
    downloadURL="https://dist.scaleft.com/repos/macos/stable/all/macos-client/$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1)/ScaleFT-$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1 | sed 's/^v//').pkg"
    appNewVersion=$(curl -s "https://dist.scaleft.com/repos/macos/stable/all/macos-client/" | grep -o 'v[0-9]\+\.[0-9]\+\.[0-9]\+' | sort -V | tail -n 1 | sed 's/^v//')
    expectedTeamID="B7F62B65BN"
    blockingProcesses=( ScaleFT )
    ;;
