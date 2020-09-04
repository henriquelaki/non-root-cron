# NON-ROOT Simplified CRON Tab

This script was made 100% over bash in order to allow users to have it's own script scheduling service in case there is no access to a cron tab

## Starting
The start command is a simple shell that works like a daemon. 
Just run it in backgroup and deatached from your terminal (nohup or screen):
```
nohup ./prod_crond.sh &
```

You should also set the environments functions defined over .setENVCRONPROV.example in order to schedule, list and delete jobs:
```
. .setENVCRONPROV.example
```



## Scheduling a script/job
To schedule a job, you should run the exported add function as shown below:
```
cron_add <your script full path> <schedule time in format HH24:MI>
```
i.e.:
```
prod_cron_add /home/myuser/send_report.sh 23:45
```
It will run script `/home/myuser/send_report.sh` at 23:45 (11:45pm) every day

## Listing Scheduled scripts/jobs
To list all scheduled scripts, just run 
```
prod_cron_list
```
It will show you an output like this:
```
===============================================================================================
                                  CRONTAB
===============================================================================================
id  	Script		Horario
1-)	/home/restartfull.sh		23:00
===============================================================================================
Remova scripts do agendamento com o comando prod_cron_del <id>
===============================================================================================
```
Where "1-)" is the scrip ID, used to remove it from schedule list

## Removing a script/job schedule
To remove a script from you scheduled jobs, just run
```
prod_cron_del <ID>
```
Where <ID> is the script id shown on prod_cron_list command output
  
## Notes
These scripts were all written based on Portuguese language, please feel free to change function names and comments to english 
