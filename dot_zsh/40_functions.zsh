# functions for zsh

if command -v gs &> /dev/null; then
    function pdfmerge() {
        if [[ $# -lt 2 || "$1" = "-h" || "$1" = "--help" ]]; then
            echo "Usage: pdfmerge [output file] [input files...]"
        else
            gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=$@ ;
        fi
    }
fi

if command -v qpdf &> /dev/null; then
    function pdfsplit() {
        if [[ $# -lt 3 || "$1" = "-h" || "$1" = "--help" ]]; then
            echo "Usage: pdfsplit [input file] [ranges] [output files]"
        else
            qpdf $1 --pages . $2 -- $3
        fi
    }
fi

if command -v python3 &> /dev/null; then
    function venv() {
        if [[ $# -lt 1 && ! -v VIRTUAL_ENV || "$1" = "-h" || "$1" = "--help" ]]; then
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

