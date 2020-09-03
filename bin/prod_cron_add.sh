#!/bin/bash
#############################################################################
# Script: prod_cron_add.sh
# Autor: Henrique Laki
# e-mail: henrique.laki.ext@nextel.coom.br
# phone: (11) 94783-0205
# Data: 15/07/202
# Descrição: Adiciona scripts com agendamento diario no horario especificado
#            para serem executados pelo job prod_cron.sh
#
#############################################################################
ROOTDIR=../
BINDIR=$ROOTDIR/bin
ETCDIR=$ROOTDIR/etc

. $BINDIR/common.sh
#Script deve receber o caminho e script a ser executado e o horario.
#Todo dia, no mesmo horario, o mesmo script será executado


proximo_indice(){
    if [ -f $SCHEDULELIST ];then
        index=`expr $(cut -d";" -f1 $SCHEDULELIST | sort -r | head -1) + 1`
    else
        index=1
    fi
    echo $index
}

agendado(){
    grep "$1" $SCHEDULELIST | grep $2 > /dev/null
    if [ $? -eq 0 ]; then
        echoerr "Script $1 já está agendado em $2."
        return 11
    fi
    return 0
}

agendar(){
    agendado "$@"
    if [ $? -gt 0 ]; then
        return $?
    else
        echo $(proximo_indice)";""$@" >> $SCHEDULELIST
        return 0
    fi
}



cron_add(){
    #verifica se o arquivo de agendamento existe, senão, cria
    if [ -f $SCHEDULELIST ]; then
        x=0;
    else
        touch $SCHEDULELIST
    fi
    SCRIPT=$1
    SCHEDULE=$2

    if [ $# -ne 2 ]; then
        echoerr "Quantidade de valores inválidos. Uso correto: prod_cron_add comando horario<HH:MI>"
        return 1
    fi

    #verifica se o script agendado existe
    if [ -f $SCRIPT ]; then
        x=0;
    else
        echoerr "Script ou comando $SCRIPT não existe."
        return 2
    fi

    #verifica se o horario agendado é valido
    TIMEMASK=(${SCHEDULE//:/ })
    if [ ${#SCHEDULE} -eq 5 ] && [ ${#TIMEMASK[@]} -eq 2 ] && [ ${TIMEMASK[0]} -le 23 -a ${TIMEMASK[1]} -le 59  ]; then
        x=0;
    else
        echoerr "Horário $SCHEDULE está no formato errado. Formato correto é HH:MI"
        return 3
    fi

    agendar "$@"
}
