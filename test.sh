#!/bin/bash

JSON_FILE="modules.json"
curl_check() {
    echo "Checking for curl..."
    if command -v curl >/dev/null; then
        echo "Detected curl..."
    else
        echo "Installing curl..."
        apt-get install -q -y curl
    fi
}
update_upgrade() {
    #Update and Upgrade
    echo "Updating and Upgrading"
    apt-get update && sudo apt-get upgrade -y
}
checks() {
    #Check if curl is installed
    curl_check

    sudo apt-get install -y dialog jq

}

_jq() {
    echo ${1} | base64 --decode | jq -re ${2}
}
make_dialog() {
    local box_message=$1
    shift
    local options=("$@")
    local cmd=(dialog --separate-output --checklist "$box_message" 22 76 16)
    local resp=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    echo "${resp[@]}"
}

check_value_in_array() {
    local ar=($(echo "$2"))

    for x in ${ar[@]}; do

        if [ "$1" == "$x" ]; then

            return 0
        fi
    done

    return 1
}

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi
else
update_upgrade
checks

SOFTWARES_TO_INSTALL=()
dialog_itens() {
    local row_dec="$1"
    local row_name=$(echo $row_dec | jq -r '.name')
    local iten_list=()
    for iten in $(echo "${row_dec}" | jq -r '.itens[] | @base64'); do
        local iten_number=$(_jq "${iten}" ".number")

        local iten_name=$(_jq "${iten}" ".name")

        local iten_switch=$(_jq "${iten}" ".switch")
        if [ "$iten_switch" = "null" ]; then
            local iten_switch="on"
        fi

        local iten_list=($iten_number $iten_name $iten_switch ${iten_list[@]})
        _jq "${iten}" ".children" >/dev/null 2>&1
        if [ "$?" == "0" ]; then
            local have_childrens=($iten_number ${have_childrens[@]})
        fi
    done

    local resp=$(make_dialog "$row_name" "${iten_list[@]}")
    # clear

    for i in $(echo "${row_dec}" | jq -r '.itens[] | @base64'); do

        # Get names from resp
        local iten_resp_number=$(_jq "${i}" ".number")
        local iten_resp_name=$(_jq "${i}" ".name")
        local resp_arr_arg=$(echo ${resp[@]})
        check_value_in_array "$iten_resp_number" "$resp_arr_arg" >/dev/null 2>&1
        if [ "$?" == 0 ]; then
            local iten_switch="on"
            SOFTWARES_TO_INSTALL=("${SOFTWARES_TO_INSTALL[@]}" "$iten_resp_name")
        fi

        local i_number=$(_jq "${i}" ".number")

        # Checa se o item tem filho
        local has_child_arr=$(echo ${have_childrens[@]})
        check_value_in_array "$i_number" "$has_child_arr" >/dev/null 2>&1
        if [ "$?" == 0 ]; then

            # Checa se usuario quer installar dependencia.
            local has_resp_arr=$(echo ${resp[@]})

            check_value_in_array "$i_number" "$has_resp_arr" >/dev/null 2>&1
            if [ "$?" == 0 ]; then

                child_dec=$(echo $i | base64 --decode)
                for children in $(echo "${child_dec}" | jq -r '.children[] | @base64'); do
                    child_dec=$(echo $children | base64 --decode)
                    dialog_itens "$child_dec"
                done

            fi

        fi

    done

}

for module in $(jq -r '.modules[] | @base64' $JSON_FILE); do
    row_dec=$(echo ${module} | base64 --decode)
    dialog_itens "$row_dec"

done

echo "Installing ( ${SOFTWARES_TO_INSTALL[@]} ) Softwares ... "
cd install
for software in ${SOFTWARES_TO_INSTALL[@]}; do
    eval "./$software.sh"
    if [ "$?" == 0 ]; then
        echo "------->$software had a problem<-------"
    fi

done
