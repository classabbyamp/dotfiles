# functions for zsh

if which gs > /dev/null; then
    function pdfmerge() {
        if [[ "$#" -lt 2 || "$1" -eq "-h" || "$1" -eq "--help" ]]; then
            echo "Usage: pdfmerge [output file] [input files...]"
        else
            gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ;
        fi
    }
fi

if which python3 > /dev/null; then
    function venv() {
        if [[ "$1" -eq "-h" || "$1" -eq "--help" ]]; then
            echo "Usage:"
            echo "  Activate: venv [venv to activate]"
            echo "  Deactivate: venv"
        elif [[ ! -v VIRTUAL_ENV ]] ; then
            if [[ ! -z "$1" ]] ; then
                echo "Activating $1..."
                source ./$1/bin/activate
            else
                echo "No venv specified"
                return 1
            fi
        elif [[ -v VIRTUAL_ENV ]] ; then
            echo "Deactivating..."
            deactivate
        fi
    }
fi

