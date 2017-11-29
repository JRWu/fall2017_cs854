#!/bin/bash

# DEFINE DIRECTORIES
RESULTSDIR="/home/j2zhao/Documents/fall2017_cs854/results/"
ARCH="ARCH_"
WEBSERVER="WEBSERVER_"
FILESERVER="FILESERVER_"
VARMAIL="VARMAIL_"
OLTP="OLTP_"
WEBPROXY="WEBPROXY_"
VIDEOSERVER="VIDEOSERVER_"
EXT=".txt"

# Creates directory /data/results if does not exist
echo "CHECKING IF RESULTS DIRECTORY EXISTS"
if [ -d "/home/j2zhao/Documents/fall2017_cs854/results/" ]; then
	echo "RESULTS DIRECTORY EXISTS"
else
	echo "CREATING /home/j2zhao/Documents/fall2017_cs854/results/"
	mkdir "/home/j2zhao/Documents/fall2017_cs854/results/"
fi

echo "CHECKING IF TMP DIRECTORY EXISTS"
if [ -d "/home/j2zhao/Documents/fall2017_cs854/tmp/" ]; then
	echo "TMP DIRECTORY EXISTS"
else
	echo "CREATING /home/j2zhao/Documents/fall2017_cs854/tmp/"
	mkdir "/home/j2zhao/Documents/fall2017_cs854/tmp"
fi

echo "DETERMINING FS"
XYZ=`df -TH | grep "^/dev"`
FS=`./src/determineFS.sh $XYZ`
echo "USING FILESYSTEM: "$FS

# Configures the filebench settings 
echo "CONFIGURING AND BUILDING FILEBENCH"
cd /home/j2zhao/Documents/fall2017_cs854/filebench/filebench-1.5-alpha3/
./configure > /dev/null
make > /dev/null
sudo make install > /dev/null
echo "CONFIGURATION AND BUILD DONE"

# This is to make the benchmarks run
echo 0 > /proc/sys/kernel/randomize_va_space


echo "CD into /home/j2zhao/Documents/fall2017_cs854"
cd /home/j2zhao/Documents/fall2017_cs854


# webserver, varmail, fileserver can be specified by time
# oltp, videoserver, webproxy are specified by execution 
echo "RUNNING BENCHMARKS"
for i in `seq 1 5`
do
	echo "RUNNING "$WEBSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/arch_webserver.f > $RESULTSDIR$ARCH$FS$WEBSERVER$i$EXT

	echo "RUNNING "$FILESERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/arch_fileserver.f > $RESULTSDIR$ARCH$FS$FILESERVER$i$EXT

	echo "RUNNING "$VARMAIL$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/arch_varmail.f > $RESULTSDIR$ARCH$FS$VARMAIL$i$EXT

	echo "RUNNING "$WEBPROXY$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/arch_webproxy.f > $RESULTSDIR$ARCH$FS$WEBPROXY$i$EXT

	echo "RUNNING "$VIDEOSERVER$i$EXT
	./filebench/filebench-1.5-alpha3/filebench -f workloads/arch_videoserver.f > $RESULTSDIR$ARCH$FS$VIDEOSERVER$i$EXT

done


