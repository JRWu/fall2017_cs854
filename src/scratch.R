
# Combined Scatterplot
shps <- c(0:4)

ymax <- max(as.numeric(unlist(dock.list.workloads)))
ymin <- min(as.numeric(unlist(dock.list.workloads)))

df <- dock.list.workloads[[workloads[1]]]
d.df <- reshape(df, direction="long", varying=list(1:5))
colnames(d.df) <- c("fs","mbps","id")
d.df$mbps <- as.numeric(d.df$mbps)
plot(d.df$id, d.df$mbps, ylim=c(ymin,ymax), xaxt="n", pch=shps[1], col=plotcolours[1])
axis(1, at=1:length(filesystems), labels=filesystems)

for (w in 2:length(workloads))
{
	df <- dock.list.workloads[[workloads[w]]]
	d.df <- reshape(df, direction="long", varying=list(1:5))
	colnames(d.df) <- c("fs","mbps","id")
	d.df$mbps <- as.numeric(d.df$mbps)

	points(d.df$id, d.df$mbps, pch=shps[w], col=plotcolours[w])
}


