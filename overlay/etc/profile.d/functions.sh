#!/bin/sh

e_colour () {
    NC='\033[0m'
    echo -e " - ${2}${1}${NC}"
}
e () { echo '\033[0m' ${1}; }
e_exit () { e_colour '\033[0;31m' $1; exit 1; }
e_done () { e_colour '\033[1;32m' "done"; }
