#!/bin/bash

# Bash script to save all the payloads that are available on the DuckToolKit web site.
# Everything related to TOTCNT in the script can be removed, it's just used to offer
# some "graphical" view of the progress instead of a dead silent prompt as the script
# executes. Cosmetics for restless users...
# Saves the files in the subdir of "pl-repo" that is located/created in the same dir
# as from where this bash script is executed.

URL="https://ducktoolkit.com/userscripts"
WHAT_TO_LOOK_FOR="data-href="
B64INIT="{\"b64ducktext\":\""
TOTCNT=0
CNT=0
SAVEDIR=$(pwd)
SAVESUBDIR="pl-repo"

mkdir -p "$SAVEDIR/$SAVESUBDIR"

all_the_payloads=$(curl -s $URL | grep $WHAT_TO_LOOK_FOR | awk -F $WHAT_TO_LOOK_FOR\" {'print $2'} | cut -d '"' -f1)
payloads_array=($(echo $all_the_payloads | tr " " "\n"))

for i in "${payloads_array[@]}"
do
	((TOTCNT=TOTCNT+1))
done


for i in "${payloads_array[@]}"
do
	((CNT=CNT+1))
	B64OUTPUT=$(curl -s $URL"/"$i | grep $B64INIT | awk -F $B64INIT {'print $2'} | cut -d '"' -f1)
	echo "$B64OUTPUT" | base64 -d > "$SAVEDIR/$SAVESUBDIR/payload$CNT.txt"
	clear
	echo "$CNT of $TOTCNT payloads processed..." 
done

echo "Done!"
