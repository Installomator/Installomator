#!/bin/zsh

export PATH=/usr/bin:/bin:/usr/sbin:/sbin

blockingProcesses=( Notes firefox "Activity Monitor" "Microsoft Word" )


# functions
consoleUser() {
    scutil <<< "show State:/Users/ConsoleUser" | awk '/Name :/ { print $3 }'
}

runAsUser() {  
    cuser=$(consoleUser)
    if [[ $cuser != "loginwindow" ]]; then
        uid=$(id -u "$cuser")
        launchctl asuser $uid sudo -u $cuser "$@"
    fi
}

displaydialog() { # $1: message
    message=${1:-"Message"}
    runAsUser /usr/bin/osascript -e "button returned of (display dialog \"$message\" buttons {\"Not Now\", \"Quit and Update\"} default button \"Quit and Update\")"
}


countedProcesses=1
countedErrors=0
while [[ $countedProcesses -ne 0 ]]; do
    countedProcesses=0
    for x in ${blockingProcesses}; do
        if pgrep -xq "$x"; then
            echo "process $x is running"
            # pkill $x
            button=$(displaydialog "The Application $x needs to be updated. Quit the app to continue updating?")
            if [[ $button = "Not Now" ]]; then
                echo "user aborted update"
                exit 1
            else
                runAsUser osascript -e "tell app \"$x\" to quit"
            fi
            countedProcesses=$((countedProcesses + 1))
        fi
    done
    if [[ $countedProcesses -ne 0 ]]; then
        # give the user some time to quit the app
        sleep 10
    fi
done
