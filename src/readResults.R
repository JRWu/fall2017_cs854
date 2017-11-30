#!/bin/Rscript
# Used after parseResults.sh
# Reads the files and generates figures
#
# Dependencies:
# install.packages("gridExtra")
library(gridExtra)

#webserver <- read.table("ext4WEBSERVER_1.txt", skip=19, sep="", nrow=length(readLines("ext4WEBSERVER_1.txt"))-2)
#clean <- read.table("CLEAN_ext4WEBSERVER_1.txt", sep="", nrow=length(readLines("CLEAN_ext4WEBSERVER_1.txt"))-2, row.names=1)
#clean.summary <- readLines("CLEAN_ext4WEBSERVER_1.txt") 
#strsplit(clean.summary[length(clean.summary)], " +")

docker <- "DOCKER_"
arch <- "ARCH_"
clean <- "CLEAN_"
resultsdir <- "results/"
filesystems <- c("ext4", "reiserfs", "xfs")
workloads <- c("FILESERVER","VARMAIL","VIDEOSERVER","WEBPROXY","WEBSERVER")
runs <- c(1:5)

summ.dataframe <- data.frame(matrix(NA, nrow=length(filesystems), ncol=length(workloads)))
colnames(summ.dataframe) <- runs
rownames(summ.dataframe) <- filesystems
arch.list.workloads <- list()
dock.list.workloads <- list()
avg.arch.list.workloads <- list()

# Create Empty List Structures for storing Data
for (f in 1:length(filesystems))
{
	for (w in 1:length(workloads))
	{
		arch.list.workloads[[workloads[w]]] <- summ.dataframe
		dock.list.workloads[[workloads[w]]] <- summ.dataframe
	}
}

avg.arch.list.workloads <- summ.dataframe
avg.dock.list.workloads <- summ.dataframe
colnames(avg.arch.list.workloads) <- workloads
colnames(avg.dock.list.workloads) <- workloads

for (f in 1:length(filesystems))
{
	for (w in 1:length(workloads))
	{
		for (r in 1:length(runs))
		{
			# Read in the ArchLinux Results
			archfile <- paste(resultsdir,filesystems[f],"/",arch,clean,filesystems[f], workloads[w],"_",runs[r],".txt", sep="")
			dat <- read.table(archfile, sep="", nrow=length(readLines(archfile))-2, row.names=1)
			dat.summary <- readLines(archfile)
			mbps <- strsplit(dat.summary[length(dat.summary)], " +")[[1]][10]
			mbps.clean <- gsub("mb/s","",mbps)
			arch.list.workloads[[workloads[w]]][f,r] <- mbps.clean

			# Read in the Docker Results
			dockfile <- paste(resultsdir,filesystems[f],"/",docker,clean,filesystems[f], workloads[w],"_",runs[r],".txt", sep="")
			dat <- read.table(dockfile, sep="", nrow=length(readLines(dockfile))-2, row.names=1)
			dat.summary <- readLines(dockfile)
			mbps <- strsplit(dat.summary[length(dat.summary)], " +")[[1]][10]
			mbps.clean <- gsub("mb/s","",mbps)
			dock.list.workloads[[workloads[w]]][f,r] <- mbps.clean
		}

		fs.avg <- mean(as.numeric(arch.list.workloads[[workloads[w]]][f,]))
		avg.arch.list.workloads[f,w] <- fs.avg

		fs.avg <- mean(as.numeric(dock.list.workloads[[workloads[w]]][f,]))
		avg.dock.list.workloads[f,w] <- fs.avg
	}
}


maincex <- 2
labcex <- 1.5

##### Plotting Work  #####
plotcolours <- c("red","blue","green","yellow","black")
png(file="results/fs_benchmark_docker.png", 1000,1000)
par(mfrow=c(3,2))
# Individual Plots
for (w in 1:length(workloads))
{

	df <- dock.list.workloads[[workloads[w]]]
	d.df <- reshape(df, direction="long", varying=list(1:5))
	colnames(d.df) <- c("fs","mbps","id")
	d.df$mbps <- as.numeric(d.df$mbps)
#	dev.new()
	boxplot(mbps~id, data=d.df, col=plotcolours, main=workloads[w], ylab="Throughput (mb/s)", xaxt="n", cex.main=maincex, cex.lab=labcex)
	axis(1, at=1:length(filesystems), labels=filesystems, cex.axis=2)

}


ymax <- max(as.numeric(unlist(avg.dock.list.workloads)))
ymin <- min(as.numeric(unlist(avg.dock.list.workloads)))


df <- avg.dock.list.workloads
plot(as.numeric(df[1,]), ylim=c(ymin,ymax), xaxt="n", pch=shps[1], col=plotcolours[1], xlim=c(1,length(workloads)), main="Relative Performance",xlab="", cex.main=maincex, cex.lab=labcex, cex=maincex, ylab="Throughput (mb/s)")
lines(as.numeric(df[1,]), col=plotcolours[1])
axis(1, at=1:length(workloads), labels=workloads, cex.axis=labcex-0.1)

for (w in 2:length(workloads))
{
	df <- avg.dock.list.workloads
	points(as.numeric(df[w,]), ylim=c(ymin,ymax), xaxt="n", pch=shps[w], col=plotcolours[w], xlim=c(1,length(workloads)), cex=maincex)
	lines(as.numeric(df[w,]), col=plotcolours[w])
}
dev.off()
