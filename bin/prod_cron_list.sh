#!/bin/bash
#############################################################################
# Script: prod_cron_del.sh
# Autor: Henrique Laki
# e-mail: henrique.laki.ext@nextel.coom.br
# phone: (11) 94783-0205
# Data: 15/07/202
# Descrição: Lista os scripts no agendamento diario do processo prod_cron.sh
#
#############################################################################
ROOTDIR=../
BINDIR=$ROOTDIR/bin
ETCDIR=$ROOTDIR/etc

. $BINDIR/common.sh

lista_scripts(){
    printf "===============================================================================================\n"
    printf "                                  CRONTAB PROVISIONING\n"
    printf "===============================================================================================\n"
    printf "id  \tScript\t\tHorario\n"
    if [ -f $SCHEDULELIST ]; then
    while read line; do
        id=$(echo $line | cut -d";" -f1)
        script=$(echo $line | cut -d";" -f2 | cut -d" " -f1)
        horario=$(echo $line | cut -d";" -f2 | cut -d" " -f2)
        printf "%s-)\t%s\t\t%s\n" $id $script $horario
    done < $SCHEDULELIST
    fi
    printf "===============================================================================================\n"
    printf "Remova scripts do agendamento com o comando prod_cron_del <id>\n"
    printf "===============================================================================================\n"
}