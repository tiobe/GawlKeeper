#!/bin/bash

gk=../GawlKeeper.linux64

{
for id in $($gk -showrules 2>&1 | cut -d'|' -f 1); do
    echo -e " ----- Rule $id ------------------------------------\n";
    for f in $(find ! -type d -name "${id}*" | sort); do
        echo -e "$gk --$id $f\n"
        $gk --$id $f
    done
done
} > output

diff -u expected_output output
