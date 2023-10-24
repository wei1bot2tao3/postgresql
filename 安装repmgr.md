安装repmgr
    安装依赖
    root 执行：
    exit
    sudo yum install postgresql-devel
    sudo yum install flex
    dnf install postgresql-server-devel
    解压：
    tar -xvf /root/repmgr-5.3.3.tar.gz
    cp -r /root/repmgr-5.3.3/ /home/postgres/
    chown -R postgres:postgres /home/postgres/
    chown -R postgres:postgres /usr/local/pg15/
    开始安装：
    su - postgres
    cd repmgr-5.3.3/
    ./configure
    make install
    which pg_config
vim ~/.bashrc
    -- 报错没有什么文件：-- 最好改文件里
        export PG_CONFIG=/usr/local/pg15/bin/pg_config
        echo $PG_CONFIG
source ~/.bashrc
cd repmgr-5.3.3/
    ./configure
make install    

    配置免密 -- 也可以在配置文件里方行-- pg_hba.conf
--ssh免密步骤(操作系统用户postgres)
--1.每个节点都执行
ssh-keygen -t rsa
--2.每个节点分别执行
ssh-copy-id -i .ssh/id_rsa.pub postgres@pg2
    sudo passwd postgres
    byvsEm-123
    ssh-keygen -t rsa
ssh-copy-id postgres@pg-01
    cat .pgpass
    vim  .pgpass
172.31.254.106:5432:repmgr:repmgr:qwe
172.31.254.123:5432:repmgr:repmgr:qwe
172.31.254.124:5432:repmgr:repmgr:qwe
172.31.254.125:5432:repmgr:repmgr:qwe
    重启数据库测试免密是否成功
chmod 600 .pgpass
    pg_ctl restart
psql -p5432 -h pg2 -Urepmgr
    psql -p5432 -h 172.31.254.106 -Urepmgr
    psql -p5432 -h 172.31.254.106 -Upostgres
REINDEX DATABASE repmgr;
ALTER DATABASE repmgr REFRESH COLLATION VERSION;

主库创建配置文件repmgr.conf
rm -rf /home/postgres/repmgr.conf
mv /home/postgres/repmgr.conf.backup /home/postgres/repmgr.conf
vim /home/postgres/repmgr.conf
 mkdir pglog
cd pglog/
touch start.log

vim /home/postgres/data/pg15/postgresql.conf
shared_preload_libraries = 'repmgr'

使用repmgr命令注册主库
chmod 600 .pgpass
/usr/local/pg15/bin/repmgr -f /home/postgres/repmgr.conf primary register --force
--查看注册信息
psql -p5432 -h 10.211.55.23 -Urepmgr
CREATE EXTENSION repmgr;
select * from repmgr.nodes ;
repmgr -f /home/postgres/repmgr.conf cluster show



1.6 启动 repmgrd
exit
vim /home/postgres/data/pg15/postgresql.conf
postgresql.conf
shared_preload_libraries = 'repmgr'
重启数据库
su postgres
pg_ctl restart
启动 repmgrd 服务
# 创建日志文件，repmgrd 的日志文件需要手动创建
mkdir -p /home/postgres/data/repmgr/
touch /home/postgres/data/repmgr/repmgrd.log
chown postgres:postgres /home/postgres/data/repmgr
chmod 700 /home/postgres/data/repmgr
启动
/usr/local/pg15/bin/repmgrd -f /home/postgres/repmgr.conf start
检查：
repmgr -f repmgr.conf  cluster show
repmgr service status --detail

备用节点
vim /home/postgres/repmgr.conf
mkdir /home/postgres/data/pglog
cd /home/postgres/data/pglog/

touch start.log


克隆备库
/usr/local/pg15/bin/repmgr -h pg2 -U repmgr -d repmgr -f /home/postgres/repmgr.conf standby clone --dry-run
/usr/local/pg15/bin/repmgr -h pg2 -U repmgr -d repmgr -f /home/postgres/repmgr.conf  standby clone
启动备库
/usr/local/pg15/bin/pg_ctl -D /home/postgres/data/pg15 start -o '-c config_file=/home/postgres/data/pg15/postgresql.conf' -l  /home/postgres/data/pglog/start.log
注册从库为备用服务器
/usr/local/pg15/bin/repmgr -f /home/postgres/repmgr.conf  --upstream-node-id=2 standby register

启动 repmgrd 服务
CREATE EXTENSION repmgr;
# 创建日志文件，repmgrd 的日志文件需要手动创建
mkdir -p /home/postgres/data/repmgr/
touch /home/postgres/data/repmgr/repmgrd.log
chown postgres:postgres /home/postgres/data/repmgr
chmod 700 /home/postgres/data/repmgr
/usr/local/pg15/bin/repmgrd -f /home/postgres/repmgr.conf start

见证服务器（witness）

vim /home/postgres/repmgr.conf
cd /home/postgres/data
mkdir pglog
cd pglog/
touch start.log
initdb -D /home/postgres/data/pg15
scp postgresql.conf pg1:/home/postgres/data/pg15/
scp pg_hba.conf pg1:/home/postgres/data/pg15/
/usr/local/pg15/bin/pg_ctl -D /home/postgres/data/pg15 start -o '-c config_file=/home/postgres/data/pg15/postgresql.conf' -l  /home/postgres/data/pglog/start.log
psql
create user repmgr with superuser password 'qwe' connection limit 10;
create database repmgr owner  repmgr;
CREATE EXTENSION repmgr;

启动 repmgrd 服务

# 创建日志文件，repmgrd 的日志文件需要手动创建
mkdir -p /home/postgres/data/repmgr/
touch /home/postgres/data/repmgr/repmgrd.log
chown postgres:postgres /home/postgres/data/repmgr
chmod 700 /home/postgres/data/repmgr
/usr/local/pg15/bin/repmgrd -f /home/postgres/repmgr.conf start


vim 

/usr/local/pg15/bin/repmgr -f /home/postgres/repmgr.conf witness register -h pg2

检查：
repmgr cluster show
repmgr service status --detail

在备库 node1上执行切换, 切换为主库


方法1：
rm -rf /home/postgres/data/pg15/*

/usr/local/pg15/bin/repmgr -h pg2 -U repmgr -d repmgr -f /home/postgres/repmgr.conf standby clone --dry-run
/usr/local/pg15/bin/repmgr -h pg2 -U repmgr -d repmgr -f /home/postgres/repmgr.conf standby clone
[postgres@pg-01 ~]$ pg_ctl start
 repmgr -f /home/postgres/repmgr.conf standby register --force
/usr/local/pg15/bin/repmgrd -f /home/postgres/repmgr.conf start


chmod 0600 /home/postgres/.pgpasspg_is_in_recovery
repmgr -f /home/postgres/repmgr.conf node rejoin -d'host=10.211.55.19 user=repmgr dbname=repmgr connect_timeout=2' --force-rewind



日志文件
tail /home/postgres/data/repmgr/repmgrd.log

方法2 强制 同步到现在
 repmgr -f /home/postgres/repmgr.conf node rejoin -d 'host=10.211.55.20 user=repmgr dbname=repmgr connect_timeout=2'   --verbose
psql 'host=10.211.55.22 user=repmgr password=lhr dbname=repmgr connect_timeout=2'


命令：
repmgr node status：显示当前节点的状态信息，包括节点 ID、角色、连接信息、复制延迟等。

repmgr cluster show：显示整个复制集的状态信息，包括所有节点的信息、角色、连接信息、复制延迟等。

repmgr cluster show --compact：以紧凑的格式显示整个复制集的状态信息。

repmgr cluster show --csv：以 CSV 格式显示整个复制集的状态信息。

repmgr standby follow：将当前节点切换为指定的主节点的从节点。

repmgr standby promote：将当前节点切换为主节点。

repmgr standby switchover：执行故障切换操作，将当前主节点切换为从节点，并将指定的从节点提升为新的主节点。

repmgr standby demote：将当前主节点降级为从节点。

repmgr standby unregister：从复制集中注销当前节点。

repmgr standby register：将当前节点注册到复制集中。

repmgr primary unregister：从复制集中注销当前主节点。

repmgr primary register：将当前节点注册为主节点。

repmgr primary register --force：将当前节点强制注册为主节点，即使已经存在其他主节点。

repmgr primary switchover：执行主节点切换操作，将当前主节点切换为指定的从节点，并将指定的从节点提升为新的主节点。

repmgr primary reconfigure：重新配置当前主节点的连接信息。

repmgr primary rejoin：重新加入复制集，用于修复复制集中的问题


删除节点：
在repmgr主节点上执行以下命令，将要删除的节点从集群中标记为离线：
repmgr standby unregister --node-id=4
其中，<node_id>是要删除的节点的ID。
这将从repmgr集群配置中移除要删除的节点，并更新集群状态。

在repmgr主节点上执行以下命令，将集群状态同步到所有其他节点：
repmgr cluster wait --all




$ repmgr primary register --force -f repmgr.conf
$ repmgr standby register --force -f repmgr.conf
$ repmgr witness register --force -f repmgr.conf -h primary_host