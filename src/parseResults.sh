#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Usage: ./src/parseResults.sh `DOCKER_ or ARCH_` `FILESYSTEM` "
	echo "Usage: ./src/parseResults.sh `DOCKER_` `ext4` "
	exit
fi

# DEFINE DIRECTORIES
RESULTSDIR="results/"$2"/"
DOCKER=$1
WEBSERVER="WEBSERVER_"
FILESERVER="FILESERVER_"
VARMAIL="VARMAIL_"
OLTP="OLTP_"
WEBPROXY="WEBPROXY_"
VIDEOSERVER="VIDEOSERVER_"
CLEAN="CLEAN_"
EXT=".txt"
FS=$2

#tail $RESULTSDIR$DOCKER$FS$WEBSERVER"1"$EXT

# Script run with:
# ./src/parseResults.sh "ARCH_" "ext4"
# ./src/parseResults.sh "DOCKER_" "ext4"
# ./src/parseResults.sh "ARCH_" "reiserfs"
# ./src/parseResults.sh "DOCKER_" "reiserfs"

for i in `seq 1 5`
do
	#18 header lines for webserver
	#1 tail line for webserver
	#tail $RESULTSDIR$FS$WEBSERVER$i$EXT

	tail -n +19 $RESULTSDIR$DOCKER$FS$WEBSERVER$i$EXT | head -n -1 > $RESULTSDIR$DOCKER$CLEAN$FS$WEBSERVER$i$EXT

	tail -n +15 $RESULTSDIR$DOCKER$FS$FILESERVER$i$EXT | head -n -1 > $RESULTSDIR$DOCKER$CLEAN$FS$FILESERVER$i$EXT

	tail -n +15 $RESULTSDIR$DOCKER$FS$VARMAIL$i$EXT | head -n -1 > $RESULTSDIR$DOCKER$CLEAN$FS$VARMAIL$i$EXT

	tail -n +15 $RESULTSDIR$DOCKER$FS$WEBPROXY$i$EXT | head -n -1 > $RESULTSDIR$DOCKER$CLEAN$FS$WEBPROXY$i$EXT

	tail -n +20 $RESULTSDIR$DOCKER$FS$VIDEOSERVER$i$EXT | head -n -1 > $RESULTSDIR$DOCKER$CLEAN$FS$VIDEOSERVER$i$EXT
	
done