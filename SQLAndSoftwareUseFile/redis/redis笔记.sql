1,redis-server --service-start 启动服务
2，redis-server --service-stop 终止服务
3，redis-cli  启动redis（-h ip -p port）
4，ping 检测服务
5，select[15] 切换数据库 默认16个数据库
7，set name luola  设置kv（有就修改，没有就设置）
8， get key 取值
9，setex key seconds value 设置kv及其过期时间。
10，mset k1 v1 k2 v2 设置多个kv
12，mget k1 k2 k3 获取多个值
11 append key value  在一个key后面追加数据
12 key * 查看所有（支持正则表达式）
13.exists key 判断k是否存在
14 type key 查看k对应的v是什么类型
15 del k1 k2 删除k及其对应的v
16 expire key time 设置过期时间，如果没有指定其过期时间，那么就是一直存在的。
17 ttl key 查看 key的有效时间。
18 strlen key 返回长度
19 flushdb 清空当前数据库

【哈希】
19 hset user name itluola  设置哈希 key:{k:v} v只能为字符串类型。
20 hmset key f1 v1 f2 v2 设置多个属性 
21 hkeys key 获取key的所有属性。
22 hget key f 获取f属性对应的值（跟上f2的话会返回多个值的）。
23 hgetall key  获取所有的值
23 hvals key 获取该键对应的所有f对应的属性的值。
24 如果全删直接使用 del 如果删除某个属性 hdel key f1 f2。

【列表】
1，元素类型必须也得是字符串，按插入顺序排序。
2lpush a1 a b c 在左侧依次插入 abc三个元素（包含创建过程）。
3，rpush是右侧插入
4，lpop key 删除左侧的一个值
5，rpop key 删除右侧的一个值
3，lrange a1 0 2 查看元素  包括结束索引对应的值。lrange a1 0 -1 查看所有的元素，lrange a1 0 0 查看第一个值。
4， linsert key before 或者 after 现有元素 新元素。 在中间插入元素。
5，lset key 索引 value 设置（修改）指定索引位置元素的值。
6，lrem key count value。
---删除value多少次从哪删？
count > 0 : 从表头开始向表尾搜索，移除与 VALUE 相等的元素，数量为 COUNT 。
count < 0 : 从表尾开始向表头搜索，移除与 VALUE 相等的元素，数量为 COUNT 的绝对值。
count = 0 : 移除表中所有与 VALUE 相等的值。
7，ltrim key 1 -1     保留key中 1到末尾的值，即删除第一个值。
8llen key 返回列表的长度

【无序集合】
1,特性：无序，不重复，均为字符串，没有修改操作。
2，sadd key  m1 m2 添加元素
3，smembers key 查看所有元素
4，srem a3 m1 m2 删除元素

【有序集合zset】
1，特性 有序，唯一  都是字符串 按照权重由小到大排列。
2，zadd key 权重1 m1 权重2 m2... 添加元素 
3，zrange和lrange 没有区别。
4，zrangebyscore key 权1 权2 返回权重1到权重2之间的数据。
5，zscore key m 返回m的权重值
6，zrem key m1 m2 删除指定元素
7 zremrangebyscore a4 5 6 删除a4中权重5到6之间的元素 
8，zrange key 0 -1 withscores 返回数据（包括权重）


【与python交互(包含django)】
1，pip install redis
2,django中通过redis存储session pip install django-redis-sessions==0.5.6
3，settings.py中配置
# 设置redis存储session信息
SESSION_ENGINE = 'redis_sessions.session'
# redis服务的ip地址
SESSION_REDIS_HOST = 'localhost'
# redis服务的端口号
SESSION_REDIS_PORT = 6379
# 存到哪个数据库
SESSION_REDIS_DB = 2
# 连接redis数据库的密码
SESSION_REDIS_PASSWORD = ''
# 前缀，服务器生成session的时候会有一个唯一的标识码，存到redis数据库中就是一个键 # session便是这个键  对应的就是标识码
SESSION_REDIS_PREFIX = 'session'


【主从--linux】
1主从的意义：
	--避免服务挂掉，数据丢失，数据备份作用。
	-- 实现读写分离
1，把握几个点：
	--可在同一台机器上面搭建从服务器。
	--修改redis.conf
	--复制redis.conf为slave.conf（可自行命名）
	--修改slave.conf文件
	--启动并查看主从关系。

【集群：一组通过网络连接的计算机，共同对外服务，像一个独立的服务器】
1，意义：提高服务的性能。
2，软件层面：只有一台电脑，开多个redis服务（一旦电脑坏掉，整个集群不能服务）。硬件层面：多台电脑。
3，需要了解到的知识。
	--创建集群的时候最少有三个以上的节点。
	-- 存活的节点小于总数的一半的时候整个集群无法提供服务。
	--数据的写入是经过计算确定写入到哪的，一共有16384个槽，需要依靠CRC16算法计算的得出。
	--读取和写入可能不在同一个节点上，但是可以确定的是，假设一个节点的master挂掉了salve就会替补上去。

【py和集群交互】
1需要安装一个redis-py-cluster这个包。
2 from rediscuster import StrictRedisCluster这个类，
3,，然后进行代码控制。








