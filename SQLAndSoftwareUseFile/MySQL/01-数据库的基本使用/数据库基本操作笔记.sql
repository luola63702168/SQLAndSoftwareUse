-- 数据库操作
	-- 进入数据库
	mysql -uroot -p
	mysql -uroot -pmysql

	-- 退出数据库
	exit/quit/ctrl+d

	-- sql语句结尾都有分号
	-- 数据库版本
	select version();

	-- 显示时间
	select now();

	-- 命令可以多行敲
	-- 查看所有数据库 *
	show databases; 

	-- 创建数据库
	-- create database 数据库名 charset=utf8;
	create database python04;
	create database python04new charset=utf8;
	-- 还可以
	create database python04new default charset=utf8;

	-- 查看创建数据库的语句
	-- show crate database ....
	show create database python04;

	-- 查看当前使用的数据库
	select database();

	-- 使用数据库
	-- use 数据名字
	use python04new;

	-- 删除数据库（如果数据库报错，可能是数据库理解错了，试一下~python-04~）
	-- drop database 数据库名；
	drop database python04；

-- 数据表的操作

	-- 查看当前数据库中所有表
	show tables;

	-- 创建表（创建表的时候，可能以数据库缩写作为表名前缀，也有可能用tbl作为表名前缀）
	-- auto_increment表示自动增长
	-- not null 表示不能为空
	-- primary key表示主键
	-- default 默认值
	-- create table 数据表名字（字段、类型、约束[，字段 类型 约束]）
		-- unsigned 无符号
	create table xxxxx(id int, name varchar(30));
	create table yyyyy(id int primary key not null auto_increment, name varchar(30));
	create table zzzzz(
		id int primary key not null auto_increment, 
		name varchar(30)
		); 

	-- 查看表结构
	-- desc 数据表的名字；
	desc xxxxx;

	-- 创建student表（id，name，age，high，gender，cls_id）
	-- 避免出现“ Display all 475 possibilities? (y or n)”问题，取消缩进就可以了。
	-- 最后一个“cls_id”后不可以有逗号
create table students(
	id int unsigned not null auto_increment primary key,
	name varchar(30),
	age tinyint unsigned default 0,
	high decimal(5,2),
	gender enum("男","女","中性","保密") default "保密",
	cls_id int unsigned
	);

	-- 创建classes表（id，name）
create table classes(
	id int unsigned not null auto_increment primary key,
	name varchar(30)
	);


	-- 查看表的创建语句
	-- show create table 表名字；
	show create table students;

	-- 修改表-添加字段
	-- alter table 表名 add 列名 类型；
	alter table students add birthday datetime;

	-- 修改表-修改字段：不重命名版
	-- alter table 表名 modify 列名 类型及约束；
	alter table students modify birthday date;

	-- 修改表-修改字段：重命名版
	-- alter table 表名 change 原名 新名 类型+约束；
	alter table students change birthday birth date default "1997-01-01";

	-- 数据能加尽量不要删
	-- 删除表-删除字段
	--alter table 表名 drop 列名；
	alter table students drop high;

	-- 删除表
	-- drop table 表名；
	-- drop table xxxxx;
	drop table xxxxx;


-- 数据表的增删改查（curd（创建 create，更新update，读取retrieve，删除delete））
	
	--增加
	--全列插入
	--insert [into] 表名 values（...）
	--主键字段 可以用 0 null default 来占位
	--向classes表中插入一个班级
	insert into classes values(0, "菜鸟班");

	+--------+-------------------------------------+------+-----+------------+----------------+
	| Field  | Type                                | Null | Key | Default    | Extra          |
	+--------+-------------------------------------+------+-----+------------+----------------+
	| id     | int(10) unsigned                    | NO   | PRI | NULL       | auto_increment |
	| name   | varchar(30)                         | YES  |     | NULL       |                |
	| age    | tinyint(3) unsigned                 | YES  |     | 0          |                |
	| gender | enum('男','女','中性','保密')       | YES  |     | 保密       |                |
	| cls_id | int(10) unsigned                    | YES  |     | NULL       |                |
	| birth  | date                                | YES  |     | 1997-01-01 |                |
	+--------+-------------------------------------+------+-----+------------+----------------+

	--向students表插入一个学生信息
	insert into students values(0, "小李飞刀", 20, "女", 1, "1990-01-01");
	insert into students values(null, "小李飞刀", 20, "女", 1, "1990-01-01");
	insert into students values(default, "小李飞刀", 20, "女", 1, "1990-01-01");

	--失败
	--insert into students values(default, "小李飞刀", 20, "第四性别", 1, "1990-01-01")
	--枚举中的下标从1开始，1对应的是男，对应的是女（类似索引对应值）
	insert into students values(default, "小李飞刀", 20, 1, 1, "1990-01-01");
	
	--部分插入
	--insert into 表名(列1，列2...) values(值1，值2,...)
	insert into students(name, gender) values("小乔",2);
	insert into ih_house_image(house_id, url) values(2, "FsxYqPJ-fJtVZZH2LEshL7o9Ivxn");
	--多行插入(全部插入也可以的)
	insert into students(name, gender) values("大乔",2),("貂蝉",3);
	insert into students values(default, "西施", 20, 1, 1, "1990-01-01"),(default, "王昭君", 20, 3, 1, "1990-01-01");

	--修改
	--update students set 列1=值1,列2=值2 where 条件；
	update students set gender=1; -- 全部修改
	update students set gender=1 where name="小李飞刀"; -- 只要name是小李飞刀的都修改
	update students set gender=1 where id=3; -- 只要id为3的进行修改 
	update students set age=18,gender=3 where id=9; -- 修改id为9的两个值

	--基本查询使用
		--查询所有列
		--select * from 表名;
		select * from students;
		-- 竖着显示
		select * from df_user \G; 
		--定条件查询
		select * from students where name="小李飞刀"; --查询name为小李飞刀的所有信息
		select * from students where id>3; --查询id大于三的所有信息

		--查询指定列
		--select 列1，列2，.... from 表名；
		select name,gender from students;

		--可以使用as为列指定别名
		--select 字段[as 别名], 字段[as 别名] from 数据表 where...;
		select name as 姓名, gender as 性别 from students;

		--字段的顺序
		select id as 序号, gender as 性别, name as 姓名 from students;

		-- 删除
			--物理删除
			--delete from 表名 where 条件
			delete from students;
			--逻辑删除
			--用一个字段表示，这条信息已经不可以再使用了
			--给students表调价一个is_delete字段 bit类型
			alter table students add is_delete bit default 0;
			update students set is_delete=1 where id=6;





