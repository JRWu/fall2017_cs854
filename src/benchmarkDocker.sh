#!/bin/bash

# DEFINE DIRECTORIES
RESULTSDIR="/data/results/"
WEBSERVER="WEBSERVER_"
FILESERVER="FILESERVER_"
VARMAIL="VARMAIL_"
OLTP="OLTP_"
WEBPROXY="WEBPROXY_"
VIDEOSERVER="VIDEOSERVER_"
EXT=".txt"

echo "Configuring & Building Filebench"
cd /data/filebench/filebench-1.5-alpha3/
./configure
make
sudo make install

echo 0 > /proc/sys/kernel/randomize_va_space


echo "CD into /data"
cd /data

# webserver, varmail, fileserver can be specified by time
# oltp, videoserver, webproxy are specified by execution 
echo "RUNNING BENCHMARKS"
for i in `seq 1 5`
do
	echo "RUNNING "$WEBSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/webserver.f > $RESULTSDIR$WEBSERVER$i$EXT

	echo "RUNNING "$FILESERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/fileserver.f > $RESULTSDIR$FILESERVER$i$EXT

	echo "RUNNING "$VARMAIL$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/varmail.f > $RESULTSDIR$VARMAIL$i$EXT

	echo "RUNNING "$WEBPROXY$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/webproxy.f > $RESULTSDIR$WEBPROXY$i$EXT

	echo "RUNNING "$VIDEOSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/videoserver.f > $RESULTSDIR$VIDEOSERVER$i$EXT

done


