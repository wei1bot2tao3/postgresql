repmgr是用于管理PostgreSQL复制的工具。

使用方法:
repmgr [选项] 节点 状态
repmgr [选项] 节点 检查
repmgr [选项] 节点 重新加入
repmgr [选项] 节点 服务
repmgr [OPTIONS] node status
repmgr [OPTIONS] node check
repmgr [OPTIONS] node rejoin
repmgr [OPTIONS] node service


节点状态

"节点状态"显示节点的基本信息和复制状态的概述。

需要配置文件，仅在本地节点上运行。

    --csv                 以CSV格式输出

节点检查

"节点检查"从复制的角度对节点执行一些健康检查。

需要配置文件，仅在本地节点上运行。

连接选项:
-S, --superuser=USERNAME  如果repmgr用户不是超级用户，则使用超级用户

输出选项:
--csv                     以CSV格式输出（不适用于单个检查输出）
--nagios                  以Nagios格式输出（仅适用于单个检查输出）

以下选项检查单个状态:
--archive-ready           准备归档的WAL文件数量
--downstream              所有下游节点是否连接
--upstream                节点是否连接到上游
--replication-lag         复制延迟（仅适用于备用节点）
--role                    检查节点的角色是否符合预期
--slots                   检查非活动复制槽
--missing-slots           检查缺失的复制槽
--repmgrd                 检查repmgrd是否正在运行
--data-directory-config   检查repmgr的数据目录配置

节点重新加入

"节点重新加入"将停用（已停止）的节点重新加入到复制集群中。

需要配置文件，仅在本地节点上运行。

    --dry-run               检查重新加入节点的先决条件是否满足
                              （包括是否请求使用"pg_rewind"）
    --force-rewind[=VALUE]  如果需要，执行"pg_rewind"
                              （PostgreSQL 9.4 - 提供完整的"pg_rewind"路径）
    --config-files          在执行"pg_rewind"后保留的配置文件的逗号分隔列表
    --config-archive-dir    用于临时存储保留配置文件的目录
                              （默认值: /tmp）
    -W, --no-wait           不等待节点重新加入集群

节点服务

"节点服务"执行系统服务命令以停止/启动/重启/重新加载节点
或可选择显示将执行的命令

需要配置文件，仅在本地节点上运行。

    --dry-run                 显示将执行的操作，但不执行它
    --action                  要执行的操作（"start"、"stop"、"restart"或"reload"之一）
    --list-actions            显示每个操作将执行的命令
    --checkpoint              在停止或重启节点之前发出CHECKPOINT命令
    -S, --superuser=USERNAME  如果repmgr用户不是超级用户，则使用超级用户

repmgr主页: <https://repmgr.org/>

psql -p5432 -h 10.211.55.19 -Urepmgr
