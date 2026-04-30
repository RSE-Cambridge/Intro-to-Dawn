#!/bin/bash

set -e 
function remove_values {
    file_to_change=$1
    qos=$2
    account=$3
    partition=$4
    email=$5
    sed -i "s/partition=$partition/account=<FIX_PARTITION>/g" $file_to_change
    sed -i "s/qos=$qos/qos=<FIX_QOS>/g" $file_to_change
    sed -i "s/account=$account/account=<FIX_ACCOUNT>/g" $file_to_change
    sed -i "s/mail-user=$email/mail-user=<FIX_EMAIL>/g" $file_to_change

}

if [ "$#" -ne 2 ] && [ "$#" -ne 5 ] ; then
    echo "Usage: ./remove_values.sh  <old QOS>"
    exit 1
fi
qos=$1
account=$2
email=$3
partition=$4

export -f remove_values # needed or xargs can't see the function

find . -iname '[0-9]*.sh' | xargs -I {} bash -c "remove_values '{}' $qos $account $email $partition" 