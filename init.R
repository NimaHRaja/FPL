options(stringsAsFactors = FALSE)
library(dplyr)
library(ggplot2)
library(reshape2)
# library(e1071)


DF <- read.csv("FGeek_Contributers_Week7.csv")
DF <- DF %>%  replace(is.na(.), 0)
row.names(DF) <- DF[,1] 
DF <- DF[,-1]
DF <-  t(DF)  %>% as.data.frame()