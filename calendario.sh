#!/bin/bash

thisdir=$(dirname "$0")
cd $thisdir
if [[ $# -eq 0 ]]; then
    ./calendario.py
else
    ./calendario.py $1
fi
