python3)
    # NKC Change
    name="Python 3"
    type="pkg"
    appNewVersion=$(curl --compressed https://www.python.org/downloads/macos/ | grep -e "Latest Python 3 Release" | awk '{print $8}' | sed -r 's/.{9}$//')
    downloadURL="https://www.python.org/ftp/python/$appNewVersion/python-$appNewVersion-macos11.pkg"
    expectedTeamID="DJ3H93M7VJ"
    ;;
