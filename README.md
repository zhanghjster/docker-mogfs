### 环境
#### Docker
1. make data 
#### Mysql

1. 创建db并授权

		CREATE DATABASE mogilefs; 
		GRANT ALL PRIVILEGES ON mogilefs.* TO 'mogile'@'%' IDENTIFIED BY '123456';
	

#### Tracker		
1. 初始化db

		mogdbsetup --dbhost=mysqlhost -dbname=mogilefs --dbuser=mogile --dbpass=123456

2. 启动tracker

		su mogile && mogilefsd 
						
3. 添加Host
	
		mogadm host add store1 --status=alive  {alive|down}
		mogadm host add store2 --status=alive
		mogadm host add store3 --status=alive
		
	其他命令：
	
		mogadm host delete $hostname
		mogadm host mark $hostname down
        mogadm host list
        mogadm check 检查mogfs各个系统tracker hosts device的工作状况，比如某个stored停掉了会有显示


5. 添加Device

		mogadm device add store1 1 
		
		
	其他命令
		
		mogadm device mark <hostname>  <devid> <status> 更改状态
		mogadm device modify <hostname> <devid>  [opts] 更改device的权重或者状态	
		
6. 监控

	1. mogadm check可以检查各个系统的工作状况

			root@0aa96866addc /]# mogadm check
			Checking trackers...
  			127.0.0.1:7001 ... OK

			Checking hosts...
  			[ 3] mogfs_store2 ... OK
  			[ 4] mogfs_store1 ... OK

			Checking devices...
  			host device         size(G)    used(G)    free(G)   use%   ob state   I/O%
  			---- ------------ ---------- ---------- ---------- ------ ---------- -----
  			[ 3] dev3           185.838     10.950    174.887   5.89%  writeable   N/A
  			[ 3] dev4           185.838     10.950    174.887   5.89%  writeable   N/A
  			[ 4] dev1           185.838     10.950    174.887   5.89%  writeable   N/A
  			[ 4] dev2           185.838     10.950    174.887   5.89%  writeable   N/A
  			---- ------------ ---------- ---------- ---------- ------
            total:   743.350     43.802    699.548   5.89%

	2. mogstats
	
			mogstats --db_dsn="DBI:mysql:mogilefs:host=mysqlhost" --db_user="mogile" --db_pass='123456'
	


#### Store

1. 配置文件 /etc/mogilefs/mogstored.conf

		maxconns = 10000
		httplisten = 0.0.0.0:7500
		mgmtlisten = 0.0.0.0:7501
		docroot=/mogdata


2. 启动

		mogstored -d 
		
3. 添加 device 目录
	
	一个存储设备对应一个device目录, 格式必须是/mogdata/dev$n 其中$n是设备的序号,设备序号是全局唯一的, 注意添加dev时候一定要和host对应好，如果host上没有这个dev会包找不到这个设备的错误

		mogfs_store1:
			/mogdata/dev1
			/mogdata/dev2
		
		mogfs_store2:
			/mogdata/dev3
			/mogdata/dev4
		


#### Domain
	
1. 添加domain

		mogadm domain add image  添加一个image domain
		mogadm domain add video  添加一个video domain
		mogadn domain add text   添加一个text domain
		
2. 删除domain	

		mogadm domain dekete $domain_name
		
### Class

1. 添加class

		mogadm class add image thm
2. 删除class

		mogadm class delete image thm

### 交互

1. 	上传

		mogupload --domain=text --file='anaconda-ks.cfg' --key='/anaconda.cfg'
		
2. 	查看文件
	
		mogfileinfo --domain=text --key='/anaconda.cfg'
		
3.  下载文件

		mogfetch --domain=text --key='/anaconda.cfg' --file="./output" 


### Nginx  
 
 1. 下载nginx并解压到一个目录，比如到 /opt
 
 		/opt/nginx-1.6.3/
 		
 2. 下载 nginx_mogilefs_module-1.0.4.tar.gz 并解压到 /opt/
      
       	/opt/nginx_mogilefs_module-1.0.4 
 
 3. 编译
 
 		cd  /opt/nginx-1.6.3/
 		./configure --prefix=/usr/local/nginx/ --sbin-path=/usr/local/nginx/sbin/ --conf-path=/usr/local/nginx/conf/ --pid-path=/usr/local/nginx/nginx.pid --with-pcre --add-module=../nginx_mogilefs_module-1.0.4
 		修改 obj/Makefile, 在 CFLAGS 里加入 -Wno-unused-but-set-variable 否则会报错
 		
 		 nginx 被安装到了 /usr/local/nginx 目录下
 4. 启动
 
### 添加store

### docker 添加store


## 问题：

1. 文件只保存一份，没有复制，mogilefsd 运行在debug模式下发现如下error

		crash log: Modification of a read-only value attempted at /usr/local/share/perl5/Sys/Syscall.pm line 225.
		
	原因是Sys::Syscall版本的问题，降级到0.23就能修复，办法如下：
	
		cpanm BRADFITZ/Sys-Syscall-0.23.tar.gz
		
		
2.  