pollutantmean <- function(directory, pollutant, id = 1:332) {
    for ( i in id ) 
        { 
        df <- read.csv(paste0(directory,"/",formatC(i, width=3, flag="0"),".csv"))
        if (exists("dfmerged")) dfmerged <- rbind(dfmerged, df) 
        else dfmerged <- df
        }
    mean( dfmerged[[pollutant]], na.rm = TRUE )
    }