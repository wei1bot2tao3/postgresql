系统环境部署
https://mirrors.huaweicloud.com/openeuler/
https://mirrors.huaweicloud.com/openeuler/openEuler-20.03-LTS-SP1/OS/x86_64/Packages/
root密码：byvsEm-123
yum install vim

修改服务器名： 配置hots
    vim /etc/hostname
    vim /etc/hosts
172.31.254.106 pg1
172.31.254.123 pg2
172.31.254.124 pg3
172.31.254.125 pg4

    sudo systemctl restart NetworkManager

-关闭防火墙，设置selinux(各节点）
    systemctl stop firewalld
systemctl status firewalld
    systemctl disable firewalld
    sed -i 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config

root 账户密钥互信
    ssh-keygen
    ssh-copy-id pg-01
    ssh-copy-id pg-02
    ssh-copy-id pg-03

时间同步
    yum install -y chrony
    启动
        systemctl start chronyd
    设置开机自启
        systemctl enable chronyd
    检查状态
        systemctl status chronyd
    检查时间
        timedatectl
    测试时间同步源
        chronyc -a makestep
    查看时间同步源
        chronyc sources -v
    vim /etc/chrony.conf
    # 新加3个快的，是阿里云的ntp服务
    server ntp1.aliyun.com iburst
    server ntp2.aliyun.com iburst
    server ntp3.aliyun.com iburst
    # 允许所有主机从server端同步时间
    # Allow NTP client access from local network.
    allow all
    # 即使server端无法从互联网同步时间，也同步本机时间至client
    # Serve time even if not synchronized to a time source.
    local stratum 10
    重启chrony服务
        systemctl restart chronyd
    其他机器同步时间
        vim /etc/chrony.conf
        # 添加局域网时钟服务器
        server pg1 iburst
    重启chrony服务
        systemctl restart chronyd