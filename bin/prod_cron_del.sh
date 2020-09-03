#!/bin/bash
#############################################################################
# Script: prod_cron_del.sh
# Autor: Henrique Laki
# e-mail: henrique.laki.ext@nextel.coom.br
# phone: (11) 94783-0205
# Data: 15/07/202
# Descrição: Remove scripts do agendamento diario do processo prod_cron.sh
#
#############################################################################
ROOTDIR=../
BINDIR=$ROOTDIR/bin
ETCDIR=$ROOTDIR/etc
LCKDIR=$ROOTDIR/lck
TMPDIR=$ROOTDIR/tmp

. $BINDIR/common.sh
. $BINDIR/prod_cron_list.sh

encontra_id(){
    id=$1
    linha=$(grep "^$id;" $SCHEDULELIST)
    result=$?
    if [ $result -eq 0 ]; then
        echo $linha
        return 0
    else
        echoerr "ID $id não encontrado. Liste os ids com o comando prod_cron_list"
        return 11
    fi
}

reindex(){
    echolog "Reindexando o arquivo de agendamento"
    for lckfiles in `ls $LCKDIR/*`; do
        mv $lckfiles ${lckfiles}.bkp > /dev/null 2> /dev/null
    done

    mv $SCHEDULELIST ${SCHEDULELIST}_$(date '+%Y%m%d%H%M%S')_${$}.old
    lista=$1
    tamanho=$(wc -l $lista | cut -d" " -f1)
    index=1
    while read line; do
        conteudo=$(echo $line | cut -d";" -f2)
        oldindex=$(echo $line | cut -d";" -f1)
        mv $LCKDIR/${oldindex}.lck.bkp $LCKDIR/${index}.lck  
        echo $index";"$conteudo >> $SCHEDULELIST
        index=$(expr $index + 1)
    done < $lista
}

remove_linha(){
    linha=$1
    index=$(echo $linha | cut -d";" -f1)
    echolog "Parando daemon prod_crond.sh"
    kill `ps -ef | grep prod_crond.sh | grep -v grep | awk '{print $2}'` > /dev/null 2> /dev/null
    rm $LCKDIR/${index}.lck > /dev/null 2> /dev/null
    echolog "Removendo o agendamento $linha"
    grep -v "$linha" $SCHEDULELIST > $TMPDIR/$SCHEDULELIST_${$}
    reindex $TMPDIR/$SCHEDULELIST_${$}
    echolog "Reiniciando daemon prod_crond.sh"
    nohup $BINDIR/prod_crond.sh &
}

cron_del(){
    id="$@"
    re='^[0-9]+$'
    if [ -z $id ]; then
            echoerr "Execução errada. Escolha o id do agendamento a ser removido e execute cron_del <id>. Liste os ids com o comando prod_cron_list"
            return 1
    else
        if [ ${#id} -eq 1 ] || [[ ${id[0]} =~ $re ]]; then
            linha=$(encontra_id "${id[0]}")
            if [ $? -eq 0 ]; then
                remove_linha "$linha"
            fi
        else
            echoerr "Parametro inválido. Escolha o id do agendamento a ser removido. Lista os ids com o comando prod_cron_list"
            return 2
        fi
    fi

}
