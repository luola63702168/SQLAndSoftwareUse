------------------------------------------------------------------基本操作
-- 查看所有数据库
show dbs 
-- 切换数据库
use douban 
-- 查看当前所在数据库（db本身代表当前数据库）
db  
-- 删除当前数据库
db.dropDatabase() 
-- 查看集合
show collections 
-- 删除集合
db.集合名.dorp()
-- 向一个集合中插入一条数据（其实这数据类型更接近于json 所以name也是可以不带引号的）
db.test1000.insert({"name":"xiaowang","age":10}) -- insert()相同_id的数据会报错，save（）会更新相同_id所对应的值。
-- 查找该集合中的数据
db.test1000.find() 
-- 更新数据
db.test1000.update({name:"xiaowang"},{name:"xiaozhao"}) -- 该条数据会全部替换掉
db.test1000.update({name:"xiaohong"},{$set:{name:"xiaozhang"}}) -- 这样便会只修改该条（匹配的第一条）数据中的name的值
db.test1000.update({name:"xiaowang"},{$set:{name:"xiaohong"}},{multi:true})  -- 更新所有条中，name的值（{multi:true}必须和$符一起操作才是有效的）
-- 删除数据
db.test1000.remove({name:"xiaohong"},{justOne:true}) --只会删除一条
db.test1000.remove({name:"xiaohong"}) --符合条件的全删

-----------------------------------------------------------------高级查询
-- 指定查询条件
db.test1000.find({age:30})
-- 只查一条数据
db.test1000.findOne({age:18})
-- 美化输出
db.test1000.find({age:18}).pretty()
-- 比较运算符查询
db.test1000.find({age:{$lte:18}}) --age 小于等于18 （$lt 小于 $gt 大于 $ne 不等于）
-- 范围运算符
db.test1000.find({age:{$in:[18,28,38]}}) -- 查询18 或者28 或者38 的数据 ($nin 判断不在这个范围)
-- 逻辑运算符
db.test1000.find({age:18,hometown:"桃花岛"}) -- 查询age为18 hometown为桃花岛 的数据（and）
db.test1000.find({$or:[{age:18},{hometown:"桃花岛"}]}) -- 查询age为18 或hometown为桃花岛 的数据（and）
-- 正则表达式
db.test1000.find({sku:/^abc/})  --以abc开头的sku
db.test1000.find({sku:$regex:"789$"}) -- 以789结尾的数据
-- 选中及跳过（一般都是配合使用，最好先跳过再选中）(分页)
db.test1000.find().limit(2) -- 选择前两个
db.test1000.find().skip(2)  -- 跳过前两个
db.test1000.find().skip(2).limit(2) -- 显示第二页
-- js代码查询
db.stu.find({$where:function(){return this.age<=18}})
-- 投影--只显示指定的字段（1,代表显示，不写代表不显示，但是_id必须要用0才能屏蔽掉）
db.test1000.find({$where:function(){return this.age<=30}},{name:1,_id:0,age:1})
db.test1000.find({},{name:1,_id:0,age:1}) -- 获取整个文档中所有的数据
-- 排序(1代表升序，-1代表降序)
db.test1000.find().sort({age:1,gender:-1})
--统计
db.test1000.find().count() 
db.test1000.find({age:{$gte:18}}).count() -- find()中可以写条件(条件不可以写在count()中)
db.test1000.count()
db.test1000.count({age:{$gte:18}}) --count()中可以写条件
-- 清除重复
db.stu.distinct("hometown") -- 以数组的形式列举出hometown对应的值
db.stu.distinct("hometown",{age:{$gte:18}})  --里面还可以添加条件
----------------------------------------------------------------------------------------------------------------
--数据的备份和恢复（可参考书签）
-- 备份的语法：
mongodump -h dbhost -d dbname -o dbdirectory  --本地备份可以忽略第一项
-- -h： 服务器地址， 也可以指定端⼝号
-- -d： 需要备份的数据库名称
-- -o： 备份的数据存放位置， 此⽬录中存放着备份出来的数据
mongodump -h 192.168.196.128:27017 -d test1 -o ~/Desktop/test1bak
--实例（需要切到bin目录下，另外发现需要新指定新的文件夹（不能和数据库重名））
mongodump -d test -o C:/Users/63702/Desktop/work

-- 恢复语法：
mongorestore -h dbhost -d dbname --dir dbdirectory
-- -h： 服务器地址
-- -d： 需要恢复的数据库实例
-- --dir： 备份数据所在位置
mongorestore -h 192.168.196.128:27017 -d test2 --dir ~/Desktop/test1bak/test1









