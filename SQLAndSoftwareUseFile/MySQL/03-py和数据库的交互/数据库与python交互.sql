-- 创建 "京东" 数据库
create database jing_dong charset=utf8;

-- 使用 "京东" 数据库
use jing_dong;

-- 创建一个商品goods数据表
create table goods(
    id int unsigned primary key auto_increment not null,
    name varchar(150) not null,
    cate_name varchar(40) not null,
    brand_name varchar(40) not null,
    price decimal(10,3) not null default 0,
    is_show bit not null default 1,
    is_saleoff bit not null default 0
);

-- 向goods表中插入数据

insert into goods values(0,'r510vc 15.6英寸笔记本','笔记本','华硕','3399',default,default); 
insert into goods values(0,'y400n 14.0英寸笔记本电脑','笔记本','联想','4999',default,default);
insert into goods values(0,'g150th 15.6英寸游戏本','游戏本','雷神','8499',default,default); 
insert into goods values(0,'x550cc 15.6英寸笔记本','笔记本','华硕','2799',default,default); 
insert into goods values(0,'x240 超极本','超级本','联想','4880',default,default); 
insert into goods values(0,'u330p 13.3英寸超极本','超级本','联想','4299',default,default); 
insert into goods values(0,'svp13226scb 触控超极本','超级本','索尼','7999',default,default); 
insert into goods values(0,'ipad mini 7.9英寸平板电脑','平板电脑','苹果','1998',default,default);
insert into goods values(0,'ipad air 9.7英寸平板电脑','平板电脑','苹果','3388',default,default); 
insert into goods values(0,'ipad mini 配备 retina 显示屏','平板电脑','苹果','2788',default,default); 
insert into goods values(0,'ideacentre c340 20英寸一体电脑 ','台式机','联想','3499',default,default); 
insert into goods values(0,'vostro 3800-r1206 台式电脑','台式机','戴尔','2899',default,default); 
insert into goods values(0,'imac me086ch/a 21.5英寸一体电脑','台式机','苹果','9188',default,default); 
insert into goods values(0,'at7-7414lp 台式电脑 linux ）','台式机','宏碁','3699',default,default); 
insert into goods values(0,'z220sff f4f06pa工作站','服务器/工作站','惠普','4288',default,default); 
insert into goods values(0,'poweredge ii服务器','服务器/工作站','戴尔','5388',default,default); 
insert into goods values(0,'mac pro专业级台式电脑','服务器/工作站','苹果','28888',default,default); 
insert into goods values(0,'hmz-t3w 头戴显示设备','笔记本配件','索尼','6999',default,default); 
insert into goods values(0,'商务双肩背包','笔记本配件','索尼','99',default,default); 
insert into goods values(0,'x3250 m4机架式服务器','服务器/工作站','ibm','6888',default,default); 
insert into goods values(0,'商务双肩背包','笔记本配件','索尼','99',default,default);

--后来插入的数据
insert into goods values(0,'r510vc laowang笔记本','笔记本','laowang','3399',default,default); 
	-- 查询 每个类别中最贵的笔记本的信息
	 select * from goods right join (select cate_name,max(price) as max_price, min(price) as min_price,avg(price) as avg_price,count(*) from goods group by cate_name) as goods_new_info on goods.cate_name=goods_new_info.cate_name and goods.price=goods_new_info.max_price order by goods_new_info.cate_name;

-- 拆表（先将组中对应的分类的数据新建表存起来，然后将与该表中数据相同的数据对应的名字改为该表的id，然后修改字段类型（和名字），然后添加一个外键）
	-- 插入组中查询出来的数据
	insert into goods_cates(name) select cate_name from goods group by cate_name;

	-- 关联查询 修改关联查询数据相同后 对应的数据的id（类似于外键（但不是））
	update goods as g inner join goods_cates as c on g.cate_name=c.name set g.cate_name=c.id;

	-- 修改字段名和类型（不可与上面一个操作颠倒顺序）
	alter table goods change cate_name cate_id int unsigned not null;

	-- 设置外键  （有时候会出现设置不成功的现象，是因为数据无法在外键里找到一个对应的值）（一般来说，外键是尽量少设计的）

	alter table goods add foreign key(cate_id) references goods_cates(id);  -- references 关联谁


-- 删除外键（先查看外键约束，然后删除）

	--查看外键约束
	show create table goods;
	--删除
	alter table goods drop foreign key goods_ibfk_2;



-- 一般工作中都是先有表再有数据的，上述操作只是为了更加熟练数据库的操作罢了










