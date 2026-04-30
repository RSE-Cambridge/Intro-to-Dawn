#!/bin/bash
# A common method for avoiding the overhead of spawning an external process for each matched file is:
# note -print0 might not be on all machine find versions
# find $(pwd -P) -name "slurm-*.out" -type f -print0 | xargs -0 rm
# find $(pwd -P) -name ".ipynb_checkpoints" -type d -print0 | xargs -0 rm "-rf"
# find $(pwd -P) -name "slurm-*.out" -type f -exec rm {} +
# find $(pwd -P) -name ".ipynb_checkpoints" -type d -exec rm -rf {} +
# find $(pwd -P) -name "slurm-*.out" -type f  -delete
# find $(pwd -P) -name ".ipynb_checkpoints" -type d -delete
folder1=$(pwd -P)
echo "In folder:$folder1"
cd $1

tmpfile=listSlurmfiles.txt
touch ${tmpfile}
#TODELETE_LIST=[]
echo "passedfolder:$1"  
find $1  -type f -name 'slurm-*.out' -print0 >$tmpfile
#while IFS=  read -r -d $'\0'; do
#    TODELETE_LIST+=$(sed 's/\x00/${REPLY}/g' )
#done <$tmpfile
 
find $1 -type d -name ".ipynb_checkpoints" -print0 >$tmpfile
#while IFS=  read -r -d $'\0'; do
#    TODELETE_LIST+=$(sed 's/\x00/${REPLY}/g' )
#done <$tmpfile
#
#echo -e $TODELETE_LIST

while read p1; do
  echo -e "$p1"
done <$tmpfile
#rm -f tmpfile


cd $folder1