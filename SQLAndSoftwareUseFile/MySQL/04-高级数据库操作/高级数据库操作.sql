-- 视图
	-- 创建视图(一个可以使用sql语句的虚拟的表) --这个视图的目的是：方便查数据，而不是修改数据。

	create view v_goods_info as select g.*,c.name as cate_name,b.name as brand_name from goods as g left join goods_cates as c on g.cate_id=c.id left join brand_cates as b on g.brand_id=b.id;

	-- 删除视图

	drop view v_goods_info;

	-- 视图的作用
		-- 提高了重用性，就像一个函数一样
		-- 对数据重构，却不影响程序的运行。（数据库随便改，改完之后再生成一个视图就可以了）-- 这个视图是即时性的，数据库某张与之相关的表的数据被修改了，那么视图中也是即时显示出来的。
		-- 提高了安全性，可以对不同的用户。（给开发者一个视图，视图中不包含敏感信息）
		-- 数据更加清晰的显示。

-- 事务
	-- mysql默认开启事务。如果自己想要做一个复杂的操作且不想被同时使用该数据库的人打扰的话。
	-- 开启事务(两种方法)
	start transaction;
	begin;
	-- 开启事务后需要提交 commirt； 要么回滚 rollback;



	-- 事务的四大特性（简单理解）
		-- 原子性：要么成功，要么不成功。
		-- 一致性：在执行命令的过程中出了问题也没关系。
		-- 隔离性：一个客户端在对数据库的一条记录操作的时候，另外一个客户端也要对该记录操作需要等待，因为另外一个上锁了。（如果等待成功，则显示修改后的数据；如果没成功，那么便会弹出超时错误）
		-- 持久性：一旦事务提交，所做的修改会永久保存到数据库。




--索引： 一种特殊的数据类型，存储的是数据表中某一个列的相关信息。（主键及外键其实都是一种索引）

	--目的：可以更加快速的查询到相关信息

	-- 查看索引
	show index from 表名;
	-- 创建索引 
		-- 如果指定字段是字符串，需要指定长度，建议长度与定义字段时的长度一致
		-- 字段类型如果不是字符串，可以不填写长度部分
	create index 索引名称 on 表名(字段名称(长度)) 
	-- 删除索引：
	drop index 索引名称 on 表名; 

	-- 插入10w条数据的py代码
	In [1]: from pymysql import connect
	   ...:
	   ...: def main():
	   ...:     # 创建Connection连接
	   ...:     conn = connect(host='localhost',port=3306,database='jing_dong',user='root',password='123456',charset='utf8'
	   ...: )
	   ...:     # 获得Cursor对象
	   ...:     cursor = conn.cursor()
	   ...:     # 插入10万次数据
	   ...:     for i in range(100000):
	   ...:         cursor.execute("insert into test_index values('ha-%d')" % i)
	   ...:     # 提交数据
	   ...:     conn.commit()
	   ...:

	In [2]: main()

	-- 开启运行时间监测：
	set profiling=1;
	-- 查找第1万条数据ha-99999
	select * from test_index where title='ha-99999';
	-- 查看执行的时间：
	show profiles;
	-- 为表title_index的title列创建索引：
	create index title_index on test_index(title(10));
	-- 执行查询语句：
	select * from test_index where title='ha-99999';
	-- 再次查看执行的时间
	show profiles;




	-- 数据少 不要建索引
	-- 数据比较多 但是这个列不常用 这些列是不需要建索引的
	-- 哪个列常用 且数据比较多 建立索引
	-- 更新和修改的频率比较高的话（修改数据，索引对应的指针也是要随之改变的，太多的索引会影响更新和插入的速度），也可以不用索引。
	--另外：mysql中也是存在联合索引（同时查询两个条件都符合的数据时使用）和唯一索引（查询时唯一索引中字段所对应的值只能出现一次）的概念的。

-- 账户（了解）

	-- 所有用户及权限信息存储在mysql数据库的user表中
	-- 查看user表的结构
	desc user;
	-- 主要字段说明：
		-- Host表示允许访问的主机
		-- User表示用户名
		-- authentication_string表示密码，为加密后的值
	-- 查看所有用户
	select host,user,authentication_string from user;

	-- 创建账户
	grant 权限列表 on 数据库 to '用户名'@'访问主机' identified by '密码';
	grant all privileges on jing_dong.* to "laoli"@"%" identified by "12345678"  --拥有所有权限

	--说明

		-- 可以操作python数据库的所有表，方式为:jing_dong.*
		-- 访问主机通常使用 百分号% 表示此账户可以使用任何ip的主机登录访问此数据库
		-- 访问主机可以设置成 localhost或具体的ip，表示只允许本机或特定主机访问
	-- 查看用户有哪些权限
	show grants for laowang@localhost;
	-- 退出root的登录
	quit

	-- 修改权限（设置成功后需要刷新权限）（参考课件或者百度文献）
 	
 	-- 远程登录，在mysqld.cnf中配置一个文件 将默认绑定的ip注释掉。然后就可以远程登录管理了。（慎用，最好别用）一般用ssh远程登录即可


-- 主从
	-- 读写分离
	-- 备份（随时备份，只要有修改就有备份--实时同步）
	-- 负载均衡 （可以更加提高服务器的效率）


	-- 导出数据库（ --default-character-set=gbk 避免win下导出数据库乱码 linux默认是utf8）
	-- jing_dong 是原数据库名
	mysqldump -uroot -p123456 jing_dong  --default-character-set=gbk > c2.sql;


	-- 恢复
	-- 先创建一个新的数据库 jing_dong_new为新名（这是因为导出来的sql文件是没有创建数据库的sql语句的）
	-- 然后
	mysqldump -uroot -p123456 jing_dong_new  --default-character-set=gbk < c2.sql;

	-- 设置主从


		-- 在主服务器Ubuntu上进行备份，执行命令：
			mysqldump -uroot -pmysql --all-databases --lock-all-tables > ~/master_db.sql
			-- 说明
			-u ：用户名
			-p ：示密码
			--all-databases ：导出所有数据库 （因为这个选项，所以sql语句中包含了数据库的创建，于是不用新建数据库了）
			--lock-all-tables ：执行操作时锁住所有表，防止操作时有数据修改
			~/master_db.sql :导出的备份数据（sql文件）位置，可自己指定


		-- 配置主服务器
			sudo vim /etc/mysql/mysql.conf.d/mysqld.cnf
			编辑设置mysqld的配置文件，设置log_bin和server-id，也就是将83和84行取消注释。
			--重启sql服务
	 		sudo service mysql restart


 		-- 配置从服务器
	 		打开相同位置的文件，不用管84行，将83行的id设置为和主服务器id不同的数字（一般可以设置ip的最后一位）
	 		-- 重新启动sql服务
	 		sudo service mysql restart


 		-- 登入主服务器Ubuntu中的mysql，创建用于从服务器同步数据使用的帐号
			mysql –uroot –p123456
			-- REPLICATION SLAVE 同步的权限 *.* 所有数据库中的所有表  两个slave分别是 用户 及密码 % 任意一台电脑都可以登录
			GRANT REPLICATION SLAVE ON *.* TO 'slave'@'%' identified by 'slave';
			-- 刷新权限	
			FLUSH PRIVILEGES;


		-- 测试
			-- 主服务器获取二进制日志信息（需登录）
			SHOW MASTER STATUS;
			-- 连接到主服务器上（master_host：主服务器Ubuntu的ip地址 master_log_file: 前面查询到的主服务器日志文件名  master_log_pos: 前面查询到的主服务器日志文件位置）
			change master to master_host='10.211.55.5', master_user='slave', master_password='slave',master_log_file='mysql-bin.000006', master_log_pos=590;
			-- 从服务器上进行验证 （当 Slave_IO_Runing 和 Slave_SQL_Runing 都显示yes的时候表示同步正常运行了。如果不是，应该是设置环节中某个变量写错了（有可能是权限有可能是二进制日志信息中的两个参数））
			show slave status \G;  -- \G为了显示的更加美观
			-- 然后在数据库中进行增删改的操作，看卡是否同步（可以没有，只要上诉条件满足，就已经配置好了主从了）
			-- 另外，一般改变数据内容的操作都是在主服务器上的，从服务器只是查询的作用。（从服务器修改数据，主服务器是不会同步的）

		-- 网上都有教程和步骤，一般都是配置linux的，当然也有win上的。








