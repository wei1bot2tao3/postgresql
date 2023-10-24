#!/bin/bash
 export PGDATABASE=postgres
 export PGPORT=5432
 export PGUSER=postgres
 export PGHOME=/usr/local/pg15
 export PATH=$PGHOME/bin:$PATH:.
PGIP=127.0.0.1
LOGFILE=/etc/keepalived/pg_keepalived.log
pg_port_status=`lsof -i :$PGPORT | grep LISTEN | wc -l`
pg_port_status=`ps -ef | grep LISTEN | wc -l`
SQL1='SELECT pg_is_in_recovery from pg_is_in_recovery();'
SQL2='update sr_delay set last_alive = now() where id =1;'
SQL3='SELECT 1;'
#此脚本不检查备库存活状态，如果是备库则退出
db_role=`echo $SQL1  | $PGHOME/bin/psql -h $PGIP -p $PGPORT -d $PGDATABASE -U $PGUSER -At -w`
if [ "$db_role" == "t" ]; then
   echo -e `date +"%F %T"` 'Attention: the current database is standby DB!' >> $LOGFILE
   exit 1
fi
if [ $pg_port_status -lt 1 ];then
    echo -e `date +"%F %T"` 'Error: The postgreSQL is not running,please check the postgreSQL server status!' >> $LOGFILE
    exit 1
fi
# 判断主库是否可用,主库更新状态
echo $SQL3 | $PGHOME/bin/psql -h $PGIP -p $PGPORT -d $PGDATABASE -U $PGUSER -At -w

if [ $? -eq 0 ]; then
   echo $SQL2 | $PGHOME/bin/psql -h $PGIP -p $PGPORT -d $PGDATABASE -U $PGUSER -At -w
   echo -e `date +"%F %T"` 'Success' >> $LOGFILE
   exit 0
else
   echo -e `date +"%F %T"` 'Error: Is the server is running?' >> $LOGFILE
   exit 1
fi
