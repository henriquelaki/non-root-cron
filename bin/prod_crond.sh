#!/bin/bash
#############################################################################
# Script: prod_crond.sh
# Autor: Henrique Laki
# e-mail: henrique.laki.ext@nextel.coom.br
# phone: (11) 94783-0205
# Data: 15/07/202
# Descrição: Daemon da cron de provisioning. Roda em loop infinito
#
#############################################################################
ROOTDIR=../
BINDIR=$ROOTDIR/bin
ETCDIR=$ROOTDIR/etc
LCKDIR=$ROOTDIR/lck
TMPDIR=$ROOTDIR/tmp
LOGDIR=$ROOTDIR/log
. $BINDIR/common.sh

executa_comando(){
    id=$1
    comando=$2
    schedule=$3
    DATA=$4
    lck=$LCKDIR/${1}.lck
    echolog "Executando $id-) $comando às $schedule"
    echo $DATA > $lck
    eval $comando > $LOGDIR/${id}_$(echo `basename $comando` | cut -d'.' -f1)_$(date '+%Y%m%d%H%M%S').log 2> $LOGDIR/${id}_$(echo  `basename $comando` | cut -d'.' -f1)_$(date '+%Y%m%d%H%M%S').err &
}


horario_maior(){
    horarioagendado=$(echo $1 | sed 's/://g')
    horarioatual=$(date '+%H%M')
    if [ $horarioagendado -eq $horarioatual ]; then
        return 0
    else
        return 1;
    fi
}

pode_executar(){
    id=$1
    dataatual=$2
    schedule=$3
    arquivo_lck=$LCKDIR/${1}.lck
    utltimaexecucao=99999999
    if [ -f $arquivo_lck ]; then
        utltimaexecucao=$(cat $arquivo_lck)
        if [ $utltimaexecucao -lt $2 ]; then
            horario_maior $3
            if [ $? -eq 0 ]; then
                return 0
            fi
        fi
    else
        horario_maior $3
            if [ $? -eq 0 ]; then
                return 0
            fi  
    fi
    return 1
}

main(){
    touch $SCHEDULELIST
    DATA=$(date '+%Y%m%d')
    while read line; do
        #para cada linha, faça
        id=$(echo $line | cut -d";" -f1)
        comando=$(echo $line | cut -d";" -f2 | cut -d" " -f1)
        schedule=$(echo $line | cut -d";" -f2 | cut -d" " -f2 )
        pode_executar $id $DATA $schedule
        if [ $? -eq 0 ]; then
            executa_comando $id $comando $schedule $DATA
        fi 
    done < $SCHEDULELIST
}

while true; do
    main
done 