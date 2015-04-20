complete <- function(directory, id = 1:332) {
  result <- data.frame(id = numeric(), nobs = numeric())
     for ( i in id ) { 
         df <- read.csv(paste0(directory,"/",formatC(i, width=3, flag="0"),".csv"))
         result <- rbind(result, data.frame(id = i, nobs = sum(complete.cases(df), deparse.level=0)))
         }
  result
}