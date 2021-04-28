sublimetext)
    # credit: Mischa van der Bent (@mischavdbent)
    name="Sublime Text"
    type="dmg"
    downloadURL="https://download.sublimetext.com/latest/stable/osx"
    appNewVersion=$(curl -fs https://www.sublimetext.com/3 | grep 'class="latest"' | cut -d '>' -f 4 | sed -E 's/ (.*[0-9]*)<.*/\1/g')
    #appNewVersion=$(curl -Is https://download.sublimetext.com/latest/stable/osx | grep "Location:" | sed -n -e 's/^.*Sublime Text //p' | sed 's/.dmg//g' | sed $'s/[^[:print:]	]//g') # Alternative from @Oh4sh0
    expectedTeamID="Z6D26JE4Y4"
    ;;
