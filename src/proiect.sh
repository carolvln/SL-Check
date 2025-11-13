#!/bin/bash

counter=0

verifica_daca_exista_broken_links() {
    local director="$1"           
    local follow_symlinks="$2"
    local RED='\033[0;31m'
    local WHITE='\033[1;37m'
    for element in "$director"/*; do
        if [ -L "$element" ]; then # link simbolic
            if [ ! -e "$element" ]; then # broken link
                echo -e "$RED Broken link: $element -> $(readlink "$element")"
                echo "Broken link: $element -> $(readlink "$element")" >> $data_ora.txt
                ((counter++))
            elif [ "$follow_symlinks" = true ] && [ -d "$element" ]; then # director
                echo -e "$WHITE Following Symlink: $element"
                verifica_daca_exista_broken_links "$(readlink -f "$element")" "$follow_symlinks"
            fi
        elif [ -d "$element" ]; then # director
            echo -e "$WHITE Se verifica directorul: $element"
            verifica_daca_exista_broken_links "$element" "$follow_symlinks"
        fi
    done
}
stergere() {
    local director="$1"           
    for element in "$director"/*; do
        if [ -L "$element" ]; then # link simbolic
            if [ ! -e "$element" ]; then # broken link
                rm $element
            fi
        elif [ -d "$element" ]; then # director
            stergere "$element"
        fi
    done
}
main() {
    data_ora=$(date | sed 's/ /_/g')
    local GREEN='\033[0;32m'
    local WHITE='\033[1;37m'
    if [ $# -lt 1 ]; then # nu avem parametrii
        echo "Nu ati ales un director"
        exit 1
    fi
    touch $data_ora.txt
    local director="$1"
    local follow_symlinks=false

    if [ "$2" = "--follow-symlinks" ]; then # verificam daca al doilea parametru este --follow-symlinks
        follow_symlinks=true  # urmarim symlinks
    fi

    if [ ! -d "$director" ]; then # daca nu exista directorul
        echo "$director nu e director"
        exit 1
    fi
    verifica_daca_exista_broken_links "$director" "$follow_symlinks"
    echo -e "$GREEN Numar de broken links: $counter"
    echo "Numar de broken links: $counter" >>$data_ora.txt
    echo -e "$WHITE Vreti sa stergem Broken Links(DA / NU):"
    read input
    if [ "$input" = "DA" ]; then
        stergere "$director"
    fi

}

main "$@"