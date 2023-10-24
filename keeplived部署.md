keeplived 部署
keeplived 部署
安装
yum -y install keepalived
sudo rpm -ivh /root/keepalived-2.2.4-2.oe2203sp1.x86_64.rpm
sudo yum install lsof
2、编辑配置文件
主配置文件：
sudo yum install lsof
sudo setenforce 0
vim /etc/keepalived/keepalived.conf
mv  /etc/keepalived/keepalived.conf  /etc/keepalived/keepalived.conf.d
vim /etc/keepalived/check_pgsql.sh
rm -rf /etc/keepalived/keepalived.conf
主程序文件：/usr/sbin/keepalived
systemctl stop keepalived
systemctl status keepalived
systemctl start keepalived
systemctl restart keepalived
mkdir /tools
cd /tools/
/tools/master.sh
chmod +x 


PostgreSQL数据库配置
在主库创建表sr_delay，后续Keepalived每探测一次会刷新这张表的last_alive字段为当前探测时间，这张表用来判断主备延迟，数据库故障切换时会用到这张表。
create table sr_delay(id int4, last_alive timestamp(0) without time zone);
INSERT INTO sr_delay VALUES(1,now()) ;



sudo yum install lsof


172.31.254.123 root bjtu!@#$1011
172.31.254.124 root bjtu!@#$1011
172.31.254.125 root bjtu!@#$1011