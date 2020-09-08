#!/bin/bash
###########################################################################
# Script: common.sh
# Autor: Henrique Laki
# e-mail: henrique.laki.ext@nextel.coom.br
# phone: (11) 94783-0205
# Data: 15/07/202
# Description: Funções comuns aos scrips
#
###########################################################################
ROOTDIR=../
BINDIR=$ROOTDIR/bin
ETCDIR=$ROOTDIR/etc
LOGDIR=$ROOTDIR/log
SCHEDULELIST=$ETCDIR/schedule.lst

#Imprime mensagem em stderr
echoerr() { printf "%s:ERR:[%s %s]: %s\n" "prod_cron" "$(date '+%Y-%m-%d %H:%M:%S:%3N')" $(echo "${FUNCNAME[*]}" | sed 's/ /:/g') "$*" >&2; }

echolog() { printf "%s:LOG:[%s %s]: %s\n" "prod_cron" "$(date '+%Y-%m-%d %H:%M:%S:%3N')" $(echo "${FUNCNAME[*]}" | sed 's/ /:/g') "$*" >> prod_cron_$(date '+%Y%m').log; }



