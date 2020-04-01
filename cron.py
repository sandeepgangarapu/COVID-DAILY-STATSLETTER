from crontab import CronTab

cron = CronTab(user='root')
job = cron.new(command='python stats_generator.py')
job.hour.on(6)
cron.write()