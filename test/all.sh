#!/bin/bash

for id in $(gk -showrules 2>&1 | cut -d'|' -f 1); do
    echo -e " ----- Rule $id ------------------------------------\n";
    for f in $(find ! -type d -name "${id}*"); do
        echo -e "gk --$id $f\n"
        gk --$id $f
    done
done
