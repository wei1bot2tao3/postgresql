--源码安装PG15.2(postgres用户，所有节点)
    --创建目录及用户
    useradd postgres
    passwd postgres
byvsEm-123
    su - postgres
    mkdir -p /home/postgres/data/pg15
    mkdir -p /home/postgres/data/pgarch
    exit
    mkdir -p /usr/local/pg15
    chown -R postgres:postgres /usr/local/pg15/
    chmod 700 /home/postgres/data
rm -rf /usr/local/pg15/*
解压安装包：
sdc@BJTU1011
    tar -xvf postgresql-14.7.tar
安装部分依赖：
sudo rpm -ivh /root/
    yum install readline-devel
    yum install zlib-devel
yum install lsof -y
dnf install readline-devel
sudo rpm -ivh /root/ncurses-6.3-5.oe2203sp1.x86_64.rpm
sudo rpm -ivh /root/ncurses-base-6.3-5.oe2203sp1.noarch.rpm
sudo rpm -ivh /root/ncurses-devel-6.3-5.oe2203sp1.x86_64.rpm
sudo rpm -ivh /root/readline-devel-8.1-2.oe2203sp1.x86_64.rpm

tar -xvf /root/postgresql-14.7.tar

进入文件夹：
    cd postgresql-14.7/
    ./configure --prefix=/usr/local/pg15  --配置软件，并将其安装到指定目录。
make
    make install
配置环境变量：clea
    su - postgres
    vim ~/.bashrc
export PGDATA=/home/postgres/data/pg15
export PGHOME=/usr/local/pg15
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PGHOME/lib
export PATH=$PATH:$PGHOME/bin/
export PGPORT=5432
    source ~/.bashrc
    initdb -D /home/postgres/data/pg15 -- 主节点执行
修改配置文件：
    cd /home/postgres/data/pg15
    vim /home/postgres/data/pg15/pg_hba.conf
    vim /home/postgres/data/pg15/postgresql.conf
设置PostgreSQL开机自启(主备相同步骤设置）
    exit
    cd /root/postgresql-15.1/contrib/start-scripts/
    cp linux /etc/init.d/postgresql
    chmod +x /etc/init.d/postgresql
    vim /etc/init.d/postgresql
        # Installation prefix 修改安装目录位置
prefix=/usr/local/pg15
        # Data directory 修改数据目录位置
PGDATA="/home/postgres/data/pg15"
    chkconfig --add postgresql
    chkconfig --list postgresql

主库创建repmgr库存储元数据
    su - postgres
    pg_ctl restart
[postgres@localhost ~]$ /usr/local/pg15/bin/pg_ctl -D /home/postgres/data/pg15 start
    psql
    create user repmgr with superuser password 'qwe' connection limit 10;
    create database repmgr owner  repmgr;
create table sr_delay(id int4, last_alive timestamp(0) without time zone);
INSERT INTO sr_delay VALUES(1,now()) ;


    CREATE EXTENSION repmgr; 


danhig-miwpex-tigRi1