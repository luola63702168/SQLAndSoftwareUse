--聚合

-- 管道命令
-- 在mongodb中，⽂档处理完毕后， 通过管道进⾏下⼀次处理
$group： -- 将集合中的⽂档分组， 可⽤于统计结果（能够同时按照多个键进行分组）
$match： -- 过滤数据， 只输出符合条件的⽂档（不用find的原因是因为这是在进行管道操作）
$project： -- 修改输⼊⽂档的结构， 如重命名、 增加、 删除字段、 创建计算结果(修改输入输出的结果)
$sort： -- 将输⼊⽂档排序后输出(使用语法参考普通用法即可)
$limit： -- 限制聚合管道返回的⽂档数（limit和skip参考普通用法）
$skip： -- 跳过指定数量的⽂档， 并返回余下的⽂档
$unwind： -- 将数组类型的字段进⾏拆分

-- 表达式
-- 处理输⼊⽂档并输出
语法：表达式:'$列名'
$sum： -- 计算总和， $sum:1 表示以⼀倍计数
$avg： -- 计算平均值
$min： -- 获取最⼩值
$max： -- 获取最⼤值
$push： -- 在结果⽂档中插⼊值到⼀个数组中
$first： -- 根据资源⽂档的排序获取第⼀个⽂档数据
$last： -- 根据资源⽂档的排序获取最后⼀个⽂档数据


------------------------------------------------------
-- $group的注意点
- `$group`对应的字典中有几个键，结果中就有几个键
- 分组依据需要放到`_id`后面
- 取不同的字段的值需要使用$,`$gender`,`$age`
- 取字典嵌套的字典中的值的时候`$_id.country` （要使用“.”的方式）
- 能够同时按照多个键进行分组`{$group:{_id:{country:"$country",province:"$province"}}}`
  - 结果是：`{_id:{country:"XXX",province:"XXX"}`

-- 按照gender进行分组，获取不同组数据的个数和平均年龄
db.stu.aggregate(
  {$group:{_id:"$gender",count:{$sum:1},avg_age:{$avg:"$age"}}},
  {$project:{gender:"$_id",count:"$count",avg_age:"$avg_age",_id:0}}  -- _id:0 不让id显示（类似投影）；由于count和管道前的命名是一样的，其实我们也可以直接count:1
  )
-- 使用$group统计整个文档（_id:null即以整个文档分组）
db.stu.aggregate(
  {$group:{_id:null,count:{$sum:1},mean_age:{$avg:"$age"}}}
  )
-- 选择年龄大于20的学生或者家乡在蒙古或者大理的学生，观察男性和女性有多少人
db.stu.aggregate(
  {$match:{$or:[{age:{$gt:20}},{hometown:{$in:["蒙古","⼤理"]}}]}},
  {$group:{_id:"$gender",count:{$sum:1}}},
  {$project:{_id:0,gender:"$_id",count:1}}
  )
-- 练习
-- { "country" : "china", "province" : "sh", "userid" : "a" }  
-- {  "country" : "china", "province" : "sh", "userid" : "b" }  
-- {  "country" : "china", "province" : "sh", "userid" : "a" }  
-- {  "country" : "china", "province" : "sh", "userid" : "c" }  
-- {  "country" : "china", "province" : "bj", "userid" : "da" }  
-- {  "country" : "china", "province" : "bj", "userid" : "fa" }  
-- 需求：统计出每个country/province下的userid的数量（同一种userid只统计一次）
-- 对多个字段分组（达到去重目的）
db.tv3.aggregate(
  {$group:{_id:{country:"$country",province:"$province",userid:"$userid"}}},  -- 三个字段同时分组，对数据去重
  {$group:{_id:{country:"$_id.country",province:"$_id.province"},count:{$sum:1}}}, --count为 3+2=5
  {$project:{country:"$_id.country",province:"$_id.province",count:1,_id:0}}  -- 修改输出样式
  )

-- $sort的使用
-- 对分组后的数据进行降序排序
db.tv3.aggregate({$group:{_id:"gender",count:{$sum:1}}},{$sort:{count:-1}})

-- $unwind
-- 将⽂档中的某⼀个数组类型字段拆分成多条,每条包含数组中的⼀个值.
-- 语法：db.集合名称.aggregate({$unwind:'$字段名称'})
db.t2.insert({_id:1,item:'t-shirt',size:['S','M','L']})
db.t2.aggregate({$unwind:'$size'})
-- 结果如下：
-- { "_id" : 1, "item" : "t-shirt", "size" : "S" }
-- { "_id" : 1, "item" : "t-shirt", "size" : "M" }
-- { "_id" : 1, "item" : "t-shirt", "size" : "L" }

--(需要知道的是：当按照某一个字段拆分的时候，如果该字段为空或者不存在该字段的话，那么就会被视为异常值，不会返回)
-- 例如：
-- { "_id" : 1, "item" : "a", "size" : [ "S", "M", "L" ] }
-- { "_id" : 2, "item" : "b", "size" : [ ] }
-- { "_id" : 3, "item" : "c", "size" : "M" }
-- { "_id" : 4, "item" : "d" }
-- { "_id" : 5, "item" : "e", "size" : null }
-- 解决方法（添加：属性）
db.t3.aggregate({$unwind:{path:"$size",preserveNullAndEmptyArrays:true}})

--------------------------------------------------------------------------------------
-- 索引
for(i=0;i<100000;i++){db.t12.insert({name:'test'+i,age:i})} -- 插入十万条数据
--创建索引
--语法：db.集合.ensureIndex({属性:1})，1表示升序， -1表示降序
db.t12.ensureIndex({name:1})
-- 创建唯一索引（查询出来的name对应的值是唯一的）:
db.t12.ensureIndex({"name":1},{"unique":true})                                                           
--比较建立索引前后数据查询所用的时间
db.t12.find({name:'test10000'}).explain('executionStats')  # explain查看所用时间
-- 创建联合索引（当需要通过多个字段判断数据的唯一性（参考56行左右的代码）的时候可以建立联合索引）     
db.t12.ensureIndex({name:1,age:1})
-- 查看当前集合的所有索引：
db.t12.getIndexes()
-- 删除索引
db.t12.dropIndex({'name:1'})
it --翻页效果



mongodb mysql redis的区别和使用场景：
-- mysql是关系型数据库，支持事物
-- mongodb，redis非关系型数据库，不支持事物
-- mysql，mongodb，redis的使用根据如何方便进行选择
  -- 希望速度快的时候，选择mongodb或者是redis
  -- 数据量过大的时候，选择频繁使用的数据存入redis，其他的存入mongodb
  -- mongodb不用提前建表建数据库，使用方便，字段数量不确定的时候使用mongodb
  -- 后续需要用到数据之间的关系，此时考虑mysql