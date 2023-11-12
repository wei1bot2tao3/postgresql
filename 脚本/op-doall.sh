#!/bin/bash
#
#  didi api do 'some command;xxx'
#  didi pay scp /tmp/v2 /home/app/api
#
## 判断bug，非api pay orderdispatch hongbao 的参数不支持.

_cmd=$1
_host=$2

source /home/work/opbin/itools/init.sh

## 判断bug，非do rsync scp 的参数不支持.
if  [[ $_cmd = do ]] || \
    [[ $_cmd = scp ]] || \
    [[ $_cmd = rsync ]] || \
    [[ $_cmd = tail ]] || \
    [[ $_cmd = grep ]] || \
    [[ $_cmd = qps ]]; then
  :
else
  echo "[ERROR] : $_cmd is action parm"
  echo "action should in [do|scp|rsync|qps|tail]"
  exit -2
fi

# check bug 2
#if [[ ]] ; then
#  :
#else
#  echo "[ERROR] : \"$_host\" is not subsystem"
#  exit -1
#fi


## 判断bug，防止以/结尾的目录，这样不论是rsync还是scp都会递归复制，导致非预期.
if [ $_cmd = scp ] || [ $_cmd = rsync ] ; then
  END_CHAR=$(expr substr $3 `expr length $3` `expr length $3`)
  if [ "$END_CHAR" = "/" ] ;then
      echo "[ERROR] : Dont end with / , this might cause bug"
      exit -2
  fi
fi

##  new feather ##
_color_echo() {
        tput setaf "$1"
        shift
        echo "$@"
        tput sgr0
}

_echo_host() {
        echo -en  "====================\t"
        _color_echo 1 -n "$@"
        echo -e "\t===================="
}

## ready to go !
########### do ##########
if [ $_cmd = do ] ; then
   for i in $( ml $_host);do
     _echo_host "$i" 1>&2;
     if [ "x$3" != "x" ] ; then
        ssh -qt4 $i "source ~/.bashrc ; $3"
     else
        ssh -qt4 $i
     fi
     ret=$?
     if [[ $ret -ne 0 ]] ;then
         _color_echo 2 "ssh [$1] return $ret" 1>&2
     fi
   done
fi

########### log ##########
if [ $_cmd = tail ] ; then
  /home/work/opbin/itools/didilog.py tail "`/usr/bin/python /home/work/opbin/itools/modules.py list $_host`"  $3  $4
fi
if [ $_cmd = grep ] || [ $_cmd = qps ] ; then
  /home/work/opbin/itools/didilog.py stat "`/usr/bin/python /home/work/opbin/itools/modules.py list $_host`"  $3  $4
fi

########## scp ##########
#tmp_fifofile="/tmp/$$.fifo"
#mkfifo $tmp_fifofile
#exec 6<>$tmp_fifofile
#rm $tmp_fifofile


#thread=50
#for ((i=0;i<$thread;i++));do
#echo
#done >&6


if [ $_cmd = scp ] ;then
  for i in $( /usr/bin/python /home/work/opbin/itools/modules.py list $_host);do
  _echo_host "$i" 1>&2
#  read -u6
#  {
     if   [[ -d $3 ]] && [[ ! -z $4 ]] && [[ $3 != $4 ]];then
       scp -o UserKnownHostsFile=/dev/null -rp  $3 $i:$3
     elif [[ -d $3 ]] && [[   -z $4 ]];then
       scp -o UserKnownHostsFile=/dev/null -rp  $3 $i:${3%/*}
     elif [[ -f $3 ]] && [[ ! -z $4 ]];then
       scp -o UserKnownHostsFile=/dev/null -p   $3 $i:$4
     elif [[ -f $3 ]] && [[   -z $4 ]];then
       scp -o UserKnownHostsFile=/dev/null -p   $3 $i:$3
     else
       ret=$?
       if [[ $ret -ne 0 ]] ;then
          _color_echo 2 "[ERROR] $_cmd returned $ret" 1>&2
       fi
       #exit
     fi
#     echo >&6
#  }&
  done
#  wait
#  exec 6>&- # 关闭df6

  exit 0
fi

######### rsync #########
if [ $_cmd = rsync ] ;then
  for i in $( /usr/bin/python /home/work/opbin/itools/modules.py list $_host);do
  if   [[ -d $3 ]] && [[ ! -z $4 ]] && [[ $3 != $4 ]];then
    rsync -avzP $3 $i:$4
  elif [[ -d $3 ]] && [[   -z $4 ]];then
    rsync -avzP $3 $i:${3%/*}
  elif [[ -f $3 ]] && [[ ! -z $4 ]];then
    rsync -avzP $3 $i:$4
  elif [[ -f $3 ]] && [[   -z $4 ]];then
    rsync -avzP $3 $i:$3
  else
    echo "bad usage!"
    exit -4
  fi
  done
fi
[ K