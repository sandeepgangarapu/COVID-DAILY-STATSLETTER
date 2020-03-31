library(taskscheduleR)
test <- file.path("G:\\My Drive\\Projects\\COVID\\job_run.R")
email <- file.path("G:\\My Drive\\Projects\\COVID\\email.R")


taskscheduler_create(taskname = "rmd_render", rscript = test,
                     schedule = "DAILY", starttime = "20:00", startdate = format(as.Date("2020-03-25"), "%m/%d/%Y"))

taskscheduler_create(taskname = "email", rscript = email, 
                     schedule = "DAILY", starttime = "20:10", startdate = format(as.Date("2020-03-25"), "%m/%d/%Y"))


