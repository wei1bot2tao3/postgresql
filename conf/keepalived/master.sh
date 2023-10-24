cd /tools
vim master.sh
ip=$(hostname -I | awk '{print $1}')
dt=$(date+'%Y%m%d %H:%M:%S')
echo"$0--${ip}--${dt}">> /tmp/kp.log

vim backup.sh
ip=$(hostname -I | awk '{print $1}')
dt=$(date+'%Y%m%d %H:%M:%S')
echo"$0--${ip}--${dt}">> /tmp/kp.log
vim fault.sh
ip=$(ip addr|grep inet| grep 172.31 |awk '{print $2}')
dt=$(date +'%Y%m%d %H:%M:%S')
echo"$0--${ip}--${dt}">> /tmp/kp.log


vim stop.sh
ip=$(ip addr|grep inet| grep 172.31| awk '{print $2}')
dt=$(date +'%Y%m%d %H:%M:%S')
echo"$0--${ip}--${dt}">> /tmp/kp.log

cd /tools/ && chmod +x *.sh