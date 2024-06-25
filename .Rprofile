.First <- function(){
  
  ### load packages
  cran.packages <- c('devtools','reshape2','ggplot2','gridExtra','viridis','plyr','grid','RColorBrewer','raster')
  new.packages <- cran.packages[!(cran.packages %in% utils::installed.packages()[,"Package"])]
  if(length(new.packages)>0) install.packages(new.packages)
  
  git.packages <- c('CCAM')
  new.packages <- git.packages[!(git.packages %in% utils::installed.packages()[,"Package"])]
  if(length(new.packages)>0){
      devtools::install_github("elisvb/CCAM")
  }
  
  invisible(lapply(c(cran.packages,git.packages), function(x) require(x, character.only = TRUE)))
  
  ### source src directories (not just in main directory)
  dirs <- list.dirs()
  srcs <- grep('src',dirs,value = T)
  srcf <- unlist(sapply(srcs,list.files,full.names=T))
  invisible(sapply(srcf,source))
  
  ### ggplot layout
  theme_new <- theme_set(theme_classic())
  theme_new <- theme_update(strip.background = element_blank(),
                            axis.line.x = element_line(color="black"),
                            axis.line.y = element_line(color="black"),
                            legend.background = element_rect(fill=alpha('blue', 0)))
}
