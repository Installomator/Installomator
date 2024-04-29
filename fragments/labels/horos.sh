horos)
    name="Horos"
    type="dmg"
    versionKey="CFBundleShortVersionString"
    if [[ $(arch) == "arm64" ]]; then
    	imageName=$(curl -fs https://horosproject.org/horos-content/ | grep "arm64" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|")
        downloadURL="https://horosproject.org/horos-content/"$imageName""
        appNewVersion=$(curl -fs https://horosproject.org/horos-content/ | grep "arm64" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|" | sed -e 's/.*_\(.*\)_.*/\1/')
    elif [[ $(arch) == "i386" ]]; then
    	imageName=$(curl -fs https://horosproject.org/horos-content/ | grep -v -e "Apple" -e "arm64" -e "Nightly" | grep ".dmg" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|")
        downloadURL="https://horosproject.org/horos-content/"$imageName""
        appNewVersion=$(curl -fs https://horosproject.org/horos-content/ | grep -v -e "Apple" -e "arm64" -e "Nightly" | grep ".dmg" | tail -1 | sed "s|.*href=\"\(.*\)\">Horos.*|\\1|" | sed -e 's/.*Horos\(.*\).dmg.*/\1/')
    fi
    expectedTeamID="TPT6TVH8UY"
    ;;
