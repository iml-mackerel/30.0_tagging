#######
##
##  Tagging data from literature
##
#######

nam <- 'tagging'
wddat <- paste0('data/',nam,'/')
wdimg <- paste0('img/',nam)
DOplot <- F
library(ggrepel)

##### read data  ---------------------------------------------------------------------------------------------------------------------------------------
tag <- readexcel(paste0(wddat,"tagging_literature.xlsx"),sheet = 1)
tag <- type.convert(tag)
tag <- tag[tag$capture_nr!=0,]
tag$nr <- 1:nrow(tag)
tag$id <- as.character(tag$id)
tag$sameyear <- tag$release_year==tag$capture_year

# clean lat/long
tag$release_lat<- with(tag,release_lat_deg + release_lat_min/60)          
tag$capture_lat<- with(tag,capture_lat_deg + capture_lat_min/60)          
tag$release_long<- -with(tag,release_long_deg + release_long_min/60)          
tag$capture_long<- -with(tag,capture_long_deg + capture_long_min/60)  
tag[,grep('_min',names(tag))] <- NULL
tag[,grep('_deg',names(tag))] <- NULL

# relevel references
or <- ddply(tag,'reference',summarise,min=min(release_year))
tag$reference <- factor(tag$reference,levels(tag$reference)[order(or$min)])

##### read data  ---------------------------------------------------------------------------------------------------------------------------------------
# limits
allx <- c(tag$release_long,tag$capture_long)
ally <- c(tag$release_lat,tag$capture_lat)

xlim <- maplim(allx)
ylim <- maplim(ally)

# baseplot
pbase <- mapbase(xlim,ylim)

# final
rel <- tag[,c(1:2,grep('release',names(tag)))]
rel$release_day <- NULL
rel <- unique(rel)

thiscol <- viridis(5)
thiscol[5] <- "orange"

prel <- pbase+ 
    #geom_text_repel(data=rel,aes(x=release_long, y = release_lat, col=id,label=paste(release_month,release_year,sep='/')),size=2)+
    geom_point(data=rel,  aes(x = release_long, y = release_lat, col=id),shape=16, size=4,alpha=0.5)+
    geom_text(data=rel,  aes(x = release_long, y = release_lat, label=release_month), size=3)+
    #geom_text(data=rel,aes(x=release_long, y = release_lat,label=paste(release_month,release_year,sep='/')),size=2,hjust=0,vjust=0)+
    facet_grid(reference~., labeller = label_wrap_gen(width=22))+
    theme(legend.position = 'none',
          strip.text = element_text(colour = 'white'))+
    scale_color_manual(values=thiscol)+
    ggtitle('Release')+xlab('')

pcapt <- pbase+ 
    geom_point(data=tag[tag$sameyear==T,], aes(x = capture_long, y = capture_lat, col=id),shape=16,size=1.5,alpha=0.8,position=position_jitter(width=0.03,height=0.03))+
    geom_point(data=tag[tag$sameyear==F,], aes(x = capture_long, y = capture_lat, col=id),shape=17,size=1.5,alpha=0.8,position=position_jitter(width=0.03,height=0.03))+
    geom_text(data=tag,aes(x = capture_long, y = capture_lat, col=id, label=capture_month),size=2)+
    #geom_text(data=tag,aes(x=capture_long, y = capture_lat,label=capture_month),size=2,position=position_jitter(width=0.03,height=0.03),vjust=1)+
    facet_grid(reference~., labeller = label_wrap_gen(width=22))+
    theme(legend.position = 'none')+
    scale_color_manual(values=thiscol)+
    ylab('')+xlab('')+
    ggtitle('Recapture')

if(DOplot) saveplot(grid.arrange(prel,pcapt, ncol=2,bottom='Longitude'),nam,wdimg,c(16,24))
if(DOplot) saveplot(grid.arrange(prel,pcapt, ncol=2,bottom='Longitude'),nam,wdimg,c(16,24),type = 'pdf')

