-- 介绍： 
	1.win下端口被80占用，所以用的是7890端口映射
	2.如果想要使用其它相关命令的话，需要切到目录中去，如果不切换的话，修改路径会很麻烦（linux：/usr/local/nginx/sbin）。

linux
-- 常用命令：
	1.查看版本号：nginx -v
	2.启动：nginx 或者 start nginx
	3.停止：
		- 快速停止或关闭Nginx：nginx -s stop
		- 正常停止或关闭Nginx：nginx -s quit
	4.重加载：nginx -s reload
	5.验证配置是否正确: nginx -t


-- 有关配置文件
	- 路径：/usr/local/nginx/conf/nginx.conf
	- 配置文件有三部分组成：
		- 全局块：从配置文件开始到events之间的内容，主要会设置一些影响nginx服务器整体运行的配置指令。
			- worker_processes 1;  其值越大，代表其可支持的并发处理量越多，但是会受到硬件、软件等设备的制约。
		- events块：涉及的指令主要影响nginx服务器与用户的网络连接。
			- worker_connections 1024; 支持最大的连接数
		- http块（重点）
			- http全局块：全局配置的指令，包括文件引入、MIME-TYPE定义、日志定义、连接超时时间、单连接请求上限等。
				- pass
			- http server块：此块和虚拟主机有着密切的关系，虚拟主机从用户角度看，和一台独立的硬件主机是完全一样的，该技术产生是为了节省互联网服务器的硬件成本。
				- pass
-- 配置实例
	-- 前言：
		- location的匹配规则：https://segmentfault.com/a/1190000019138014
		- 反向代理和负载均衡的区别：前者是不同请求对应不同服务器，后者是相同请求对应不同服务器。

	-- 反向代理
		-- 作用：
			- 路由转发，隐藏真实服务器
		-- 案例1：
			- 效果： 
				- 在win下输入www.123.com 跳转到linux系统中tomcat主页面中。
				- 即：192.168.233.12:80 映射 127.0.0.1:8080
			- 过程：
				- 在linux下安装tomcat并启动 ./starup.sh 文件，使用默认端口8080
				- linux设置80和8080端口对外开放（并通过windows进行访问测试）
				- 配置hosts文件 使 www.123.com  映射 192.168.233.12
				- 配置好 nginx.conf (参考：nginx.conf1 (请查询：here))
		-- 案例2：
			- 效果：
				访问：192.168.233.12:9001/edn/ 映射到 127.0.0.1:8080/edn/;
				访问：192.168.233.12:9001/vod/ 映射到 127.0.0.1:8081/vod/;

			- 过程：

				- 准备两个tomcat服务器，配置好两个端口映射（sever.xml），分别是：8080、8081。
					- 具体流程：将其中可见端口都改了，其中8080改为8081。
				- 端口开放。
				- 在tomcat安装目录下的webapps中创建两个文件夹：edn和vod，并在其内部写好要测试访问的html文件。
				- 启动服务器
				- 配置好 nginx.conf (参考：nginx.conf2 (请查询：here))

	-- 负载均衡
		-- 作用：
			- 使服务器压力分担
		-- 策略：
			- 轮询（默认）：一个个来
				    upstream myserver{
				        server 192.168.233.12:8080 ;
				        server 192.168.233.12:8081 ;
				    }
			- 权重：大的多一点
				    upstream myserver{
				        server 192.168.233.12:8080 weight=5;
				        server 192.168.233.12:8081 weight=10;
				    }


			- ip_hash（安装ip地址的hash值进行分配）：第一次访问是哪个服务器，第二次还是。（解决session共享问题）
				    upstream myserver{
				    	ip_hash;
				        server 192.168.233.12:8080 ;
				        server 192.168.233.12:8081 ;
				    }

		    - fire：按照后端的响应时间来分配请求，响应时间短的优先分配。
				    upstream myserver{
				        server 192.168.233.12:8080 ;
				        server 192.168.233.12:8081 ;
				        fire;
				    }

		-- 案例
			- 效果:
				- win下浏览器输入192.168.233.12:80/edn/a.html,把这个请求平均分担给 192.168.233.12:8080 和 192.168.233.12:8081两个服务器中
			- 过程：
				- 准备两台tomcat服务器
				- 端口开放
				- 在两个tomcat安装目录下的webapps中创建文件夹：edn和其文件夹内部的 a.html 文件（内容别写一样）。
				- 启动服务器
				- 配置好 nginx.conf (参考：nginx.conf3 (请查询：here))

	--动静分离：所谓静态资源就是：html、css等静态文件，动态资源就是通过ajax或者直接发送的get、post、put、请求的数据库资源。
		-- 方式：
			- 静态资源和动态资源不在同一个服务器上（主流方案）
			- 静态资源和动态资源在同一个服务器上，只是通过nginx将其分开来了。
		-- 作用
			- 使请求更加高效
		-- 案例
			- 效果：
				- 浏览器中输入 192.168.233.12:80/html/a.html 可以访问 根目录下的/static/html/a.html
				- 浏览器中输入 192.168.233.12:80/image/01.jpg 可以访问 根目录下的/static/image/01.jpg
				- 实现静态资源从一个单独服务器上获取。
			- 过程：
				- 在linux根目录创建存储静态资源的目录: static/image/01.jpg和/static/html/a.html
				- 配置好nginx.conf (参考：nginx.conf4 (请查询：here))

	-- 补充：
		1、location的expires参数，提高访问效率。
			- 可通过location的expires参数设置浏览器的缓存过期时间。
			- 在这个时间内，相同的url，会发送给nginx一个请求，然后对比服务端内容有没有修改，
			- 如果服务器端的文件内容没有内容修改，则直接将缓存返回，状态码是304，
			- 如果内容被修改了，则会从服务器上下载，返回的状态码是200。
			- 这种方式很适合不经常修改的资源请求。
		2、有关locat中的内容：
			- autoindex on; 代表当请求这个资源的时候，会把该目录内容列举出来。
			- root和alias:https://jingyan.baidu.com/article/3aed632edfd12e701180916b.html

win
- pass