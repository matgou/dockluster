#!/bin/bash
#@****************************************************************************
#@ Organization : Ecloud.fr (www.ecloud.fr)
#@ Licence : GNU/GPL
#@
#@ Description :
#@              
#@ Prerequisites :
#@ Arguments :
#@
#@****************************************************************************
#@ History :
#@  - Mathieu GOULIN - 2014/08/11 : Initialisation du script
#@****************************************************************************

# Static configuration
script=`basename "$0" | cut -f1 -d"."`
log_file=/var/log/$script.log
 
# Usage function
function usage () {
    # TODO - Write the good stuff here...
    echo "$0 container_name [container_root]"
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
 
# Parameters function
check_parameters () {
    if [ -z $container_name ];
    then
        echo "container_name is not optionnal";
        help;
        exit 1;
    fi

    if [ -z $tagname ];
    then
        echo "tagname is not optionnal";
        help;
        exit 1
    fi

    if [ -z $container_root ];
    then
        container_root=/mnt/apps_ecloud_1/containers
    fi
}
 
# Parameters management
container_name=$1
tagname=$2
container_root=$3
 
check_parameters
 
#**************************************************************************
#@ Steps : Creation de l'arboressance
#**************************************************************************
write_log BEG "Début du batch de création d'environnement"
write_log INF " container_name = $container_name"

for subvolume in $container_root/$container_name \
                 $container_root/$container_name/batch \
                 $container_root/$container_name/conf \
                 $container_root/$container_name/container-mount \
                 $container_root/$container_name/data \
                 $container_root/$container_name/logs \
                 $container_root/$container_name/src
do
    write_log INF "Create subvolume $subvolume"
    btrfs subvolume create $subvolume
done

write_log INF "Update permission on share directory"
chmod 777 $container_root/$container_name/container-mount


#**************************************************************************
#@ Steps : Creation de la configuration
#**************************************************************************
container=$1
container_slug=`echo $container | sed "s/./_/"`


#Recherche max port
max=`find . -name "env.sh" | xargs grep container_port | sed "s/^.*=.\(.*\):.*/\1/" | sort | tail -1`
nextPort=$(( $max + 1 ))

cat > $container_root/$container_name/conf/env.sh << EOF
#!/bin/sh

# Environnement for name
export container_name="$container_slug"
export tag_name="$tagname"

#
export mount_dir=$container_root/$container_name
export container_mount=/appli/

#
export container_ports="$nextPort:80"
export container_link=""
EOF

#**************************************************************************
#@ Steps : Extraction des scripts standard
#**************************************************************************
cd $container_root/$container_name/
ln -sv $container_root/batch/* $container_root/$container_name/batch
#******************************************************************************
#EOF
