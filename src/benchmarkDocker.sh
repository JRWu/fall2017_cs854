#!/bin/bash

# DEFINE DIRECTORIES
RESULTSDIR="/data/results/"
DOCKER="DOCKER_"
WEBSERVER="WEBSERVER_"
FILESERVER="FILESERVER_"
VARMAIL="VARMAIL_"
OLTP="OLTP_"
WEBPROXY="WEBPROXY_"
VIDEOSERVER="VIDEOSERVER_"
EXT=".txt"

# Creates directory /data/results if does not exist
echo "CHECKING IF RESULTS DIRECTORY EXISTS"
if [ -d "/data/results/" ]; then
	echo "RESULTS DIRECTORY EXISTS"
else
	echo "CREATING /data/results/"
	mkdir "/data/results"
fi

echo "CHECKING IF TMP DIRECTORY EXISTS"
if [ -d "/data/tmp/" ]; then
	echo "TMP DIRECTORY EXISTS"
else
	echo "CREATING /data/tmp/"
	mkdir "/data/tmp"
fi

echo "DETERMINING FS"
XYZ=`df -TH | grep "^/dev"`
FS=`./src/determineFS.sh $XYZ`
echo "USING FILESYSTEM: "$FS

# Configures the filebench settings 
echo "CONFIGURING AND BUILDING FILEBENCH"
cd /data/filebench/filebench-1.5-alpha3/
./configure > /dev/null
make > /dev/null
sudo make install > /dev/null
echo "CONFIGURATION AND BUILD DONE"

# This is to make the benchmarks run
echo 0 > /proc/sys/kernel/randomize_va_space


echo "CD into /data"
cd /data

# webserver, varmail, fileserver can be specified by time
# oltp, videoserver, webproxy are specified by execution 
echo "RUNNING BENCHMARKS"
for i in `seq 1 5`
do
	echo "RUNNING "$WEBSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/webserver.f > $RESULTSDIR$DOCKER$FS$WEBSERVER$i$EXT

	echo "RUNNING "$FILESERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/fileserver.f > $RESULTSDIR$DOCKER$FS$FILESERVER$i$EXT

	echo "RUNNING "$VARMAIL$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/varmail.f > $RESULTSDIR$DOCKER$FS$VARMAIL$i$EXT

	echo "RUNNING "$WEBPROXY$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/webproxy.f > $RESULTSDIR$DOCKER$FS$WEBPROXY$i$EXT

	echo "RUNNING "$VIDEOSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/videoserver.f > $RESULTSDIR$DOCKER$FS$VIDEOSERVER$i$EXT

done


