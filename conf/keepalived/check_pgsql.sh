#!/bin/bash

# PostgreSQL连接信息
DB_HOST="10.211.55.23"    # 数据库主机名或IP地址
DB_PORT="5432"         # 数据库端口号
DB_NAME="repmgr"      # 数据库名称
DB_USER="repmgr"    # 数据库用户名
DB_PASSWORD="qwe"  # 数据库密码

# 尝试连接数据库
su - postgres -c "pg_isready -h $DB_HOST -p $DB_PORT -d $DB_NAME -U $DB_USER"
# 检查连接结果
if [ $? -eq 0 ]; then
  exit 0 #0 代表可用
else
  exit 1 #0 不可用
fi
