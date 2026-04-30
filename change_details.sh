#!/bin/bash

set -e 
function change_values {
    file_to_change=$1
    qos=$2
    account=$3
    sed -i "s/qos FIX_THIS/qos $qos/g" $file_to_change
    sed -i "s/account FIX_THIS/account $account/g" $file_to_change
    if [ "$#" -eq 4 ]; then
        reservation=$4
        sed -i "/\#\!\/bin\/bash/a #SBATCH --reservation $reservation"  $file_to_change
    fi
}

if [ "$#" -ne 2 ] && [ "$#" -ne 3 ] ; then
    echo "Usage: ./change_values.sh  <new QOS> <new Account> <new reservation; optional>"
    exit 1
fi
qos=$1
account=$2

if [ "$#" -eq 3 ]; then
    reservation=$3
fi
export -f change_values # needed or xargs can't see the function

find . -iname '[0-9]*.sh' | xargs -I {} bash -c "change_values '{}' $qos $account $reservation" 