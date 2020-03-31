library(taskscheduleR)
test <- file.path("G:\\My Drive\\Projects\\COVID_USA\\custom_stats.R")


taskscheduler_create(taskname = "custom_stats", rscript = test,
                     schedule = "DAILY", starttime = "20:00", startdate = format(as.Date("2020-03-25"), "%m/%d/%Y"))
