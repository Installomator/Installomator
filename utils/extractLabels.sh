#!/bin/zsh --no-rcs

# This script will create individual labels files from the original Installomator.sh script
# Only for internal use

label_re='^([a-z0-9\_-]*)(\)|\|\\)$'
endlabel_re='^(    |\t);;$'

label_dir="fragments/labels"

IFS=$'\n'

in_label=0
current_label=""
while read -r line; do
    if [[ $in_label -eq 0 && "$line" =~ $label_re ]]; then
        label_name=${match[1]}
        echo "found label $label_name"
        in_label=1
    fi
    if [[ $in_label -eq 1 ]]; then
        current_label=$current_label$'\n'$line
    fi
    if [[ $in_label -eq 1 && "$line" =~ $endlabel_re ]]; then
        echo $current_label > "$label_dir/${label_name}.sh"
        in_label=0
        current_label=""
    fi

done <../Installomator.sh
