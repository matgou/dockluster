#!/bin/bash
#@****************************************************************************
#@ Author : Mathieu GOULIN (mathieu.goulin@gadz.org)
#@ Organization : Ecloud (www.ecloud.fr)
#@ Licence : GNU/GPL
#@
#@ Description :
#@   Build environnement for docker container
#@ Prerequisites :
#@ Arguments :
#@
#@****************************************************************************
#@ History :
#@  - Mathieu GOULIN - 2014/07/29 : Initialise script
#@****************************************************************************

# Static configuration
script=`basename "$0" .sh`
log_file=`dirname $0`/../logs/$script.log

# Usage function
function usage () {
    # TODO - Write the good stuff here...
    echo "$0 [-s] [-d value]"
}
# Help function
function help () {
    usage
    echo
    grep -e "^#@" $script.sh | sed "s/^#@//"
}

# Log function
write_log () {
    log_state=$1
    shift;
    log_txt=$*
    log_date=`date +'%Y/%m/%d %H:%M:%S'`
    case ${log_state} in
        BEG)    chrtra="[START]"      ;;
        CFG)    chrtra="[CONF ERR]"   ;;
        ERR)    chrtra="[ERROR]"      ;;
        END)    chrtra="[END]"        ;;
        INF)    chrtra="[INFO]"       ;;
        *)      chrtra="[ - ]"        ;;
    esac
    echo "$log_date $chrtra : ${log_txt}" | tee -a ${log_file} 2>&1
}

#**************************************************************************
#@ Steps : Load Configuration
#**************************************************************************
write_log BEG "Debut du script $script"

write_log INF "Chargement de la configuration"
. `dirname $0`/../conf/env.sh

#**************************************************************************
#@ Steps : Docker build
#**************************************************************************
write_log BEG "Build du tag docker"
if [ -f $mount_dir/src/Dockerfile ]
then
    docker build --no-cache=true -t $tag_name $mount_dir/src
    RC=$?
    write_log END "Fin du script $script : Exit => $RC"
else
    write_log INF "No build needed"
fi
exit $RC
