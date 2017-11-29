webserver <- read.table("ext4WEBSERVER_1.txt", skip=19, sep="", nrow=length(readLines("ext4WEBSERVER_1.txt"))-2)



clean <- read.table("CLEAN_ext4WEBSERVER_1.txt", sep="", nrow=length(readLines("CLEAN_ext4WEBSERVER_1.txt"))-2, row.names=1)


clean.summary <- readLines("CLEAN_ext4WEBSERVER_1.txt") 
strsplit(clean.summary[length(clean.summary)], " +")
