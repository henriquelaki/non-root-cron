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
cron_add /home/myuser/send_report.sh 23:45
```
It will run script `/home/myuser/send_report.sh` at 23:45 (11:45pm) every day
