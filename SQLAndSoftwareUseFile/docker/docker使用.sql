关于docker：
	- 理念之一：将应用与其应用的环境进行打包
	- 仓库>镜像>容器
	- 一个容器最好只运行一种服务。
	- 下列记录基于linux

-- 启动容器(IMAGE:指定启动容器所使用的操作系统镜像；[COMMAND][ARG]：容器启动后要执行的命令和参数)
docker run IMAGE [COMMAND][ARG]
例:docker run ubuntu echo 'hello world'


-- 启动交互式容器
docker run -i -t IMAGE /bin/bash
	-i :意为docker的守护进程为容器始终打开标准输入
	-t :意为打开一个伪tty终端
	/bin/bash的作用是因为docker后台必须运行一个进程，否则容器就会退出，在这里表示启动容器后启动bash
例：docker run -i -t ubuntu /bin/bash

-- 退出
exit

-- 查看内存占用
docker system df

-- ps命令
docker ps ：查看正在运行中的容器； docker ps -a ：查看所有的容器；  docker ps -l ：查看最近一次运行的容器。
 
 -- 查看已经建立好的容器的相关信息
docker inspect ID或者name
例：docker inspect 9558b14d4ccc

-- 自定义容器名字
docker run --name=自定义名字 -i -t IMAGE /bin/bash
例如：docker run --name=rusi -i -t ubuntu /bin/bash

-- 重新启动已经停止的容器
docker start[-i] 容器名
	-i :以交互的模式
例：docker start -i rusi

-- 删除容器（只能删除已经停止的容器）
docker rm 容器名


-- 守护式容器：可以长期运行，没有交互式回话，适合运行应用程序和服务。
	- 使用ctrl q 后ctrl p 退出即可
	-- 怎样打开已经退出了的守护式容器？
	例： docker attach rusi

	-- 如何使用run命令启动守护式容器(-d:告诉后台，启动的时候使用后台的方式)
	例如：docker run -- name dc1 -d /bin/sh -C "while true; do echo hello world; sleep 1; done"

	-- 查看容器日志，不指定参数，会返回所有的日志（[-f]：一直跟踪日志的便会并返回结果（退出是ctrl c） [-t]：在返回的结果上加上时间戳 [-tail]：选择返回结尾处多少数量的日志（不知道就是所有，也就是--tail="all"））
	docker logs [-f] [-t] [--tail] 容器名
	例：docker logs -tf --tail 0 dc1 显示最新的日志

	-- 查看容器内的进程
	docker top 容器名(比如查看ip)
	例；docker top dc1

-- 如何在运行中的容器内启动新的进程
	docker exec [-d] [-i] [-t] 容器名 [COMMAND][ARG]

	例:docker exec -i -t dc1 /bin/bash 
	(此时使用top命令就会发现存在两个进程了)


-- 如何停止守护式容器
	docker stop 容器名   （发送信号给容器，等待容器的停止）
	docker kill 容器名	 （直接杀死）



-- 案例
-- 部署静态网站
	- 启动（映射80端口Ubuntu容器）可参考：https://www.cnblogs.com/zhujingzhi/p/9656369.html
	docker run -p 80 --name web -i -t ubuntu /bin/bash
	- 安装nginx，vim（如果报未找到错误：apt-get update  apt-get upgrade）
	apt-get install -y nginx
	apt-get install -y vim
	- 在/var/www/html中写个静态页面并配置nginx路由
	- nginx运行（nginx）
	--查看容器端口映射
	docker port 容器名
	- curl http://127.0.0.1:32768/ 验证
	- 重启后，分配的ip地址和端口映射都会改变（除非最开始的时候设置为固定的）



-- 镜像
	-- 查看存储驱动和存储位置：
	docker info
	-- 列出镜像（-a:显示所有镜像，默认不显示中间层镜像；-f:显示时的过滤条件（直接在images后面跟仓库名即可）； --no-trunc:不截断镜像的唯一id；-q：只显示镜像的唯一id）
	-- （1、镜像所属仓库名；2、镜像的标签名，标识每个仓库中不同镜像的标签名；3、时间；4、建立时间；5、大小）
	-- 仓库名和标签名，联合确定一个镜像；-a的时候会发现有仓库名和标签名都为none的时候说明是中间层镜像
	docker images
	-- 查看镜像
	docker inspect 镜像完整形式（仓库名:标签）或id来查看   ->默认标签为latest
	例： docker inspec ubuntu:16.04
	-- 删除镜像(-f:强制删除镜像；-no-prune:保留被删除镜像中被打标签的父镜像)
	-- 可以是镜像完整形式或id（如果是前者，可能存在多个标签对应一个id，也就只会删除一个标签了，并没有真正的删除，所以如果想真正的删除的话，建议直接使用docker rmi ID 的形式）
	docker rmi
	例：docker rmi ubuntu:16.04
	-- 删除多个镜像
	可以在 docker rmi 后跟上多个镜像完整形式
	-- 删除所有镜像(并没有这样的选项，但是可以配合别的命令使用)	
	例： 删除所有的ubuntu镜像：docker rmi $(docker images -q ubuntu)
	-- 查看镜像的构建过程
	docker history 
-- 获取和推送镜像
	-- 查找镜像；最多一次返回25个结果(-automated :只会显示自动化构建出的docker镜像；-no-trunc:不以截断的形式显示 -s:限制显示结果的最低星级)
	docker search 镜像名
	例： docker search -s 3 ubuntu
	-- 拉取镜像（-a:将所有匹配的镜像全部下载到本地）
	docker pull
	例： docker pull ubuntu:16.04 (会下载所有匹配的镜像，也许这些镜像的id都是一样的)
	-- 推送镜像
	docker push 镜像名

-- 构建docker镜像（重要）
	意义：1、保存对容器的修改，并再次使用；2、自定义镜像的能力；3、以软件的形式打包并分发服务及其运行环境。
	# 通过容器构建（-a "作者的相关信息"；-m "记录镜像构建的信息"；-p "指定不暂停正在运行的容器"）
	- docker commit 容器名 想要构建的镜像名
		- docker run -it -p 80 --name commit_test ubuntu /bin/bash 启动一个用于测试的交互式容器
	例：docker commit -a "rusi rusiwillbeok@sina.com" -m "nginx" commit_test rusiwillbeok/commit_test:rusi
	测试：
		-- 查看镜像
		- docker images  
		--利用该镜像创建一个后台容器； -g "daemon off;"：令nginx以前台形式开启，避免后台时没有pid=1的进程，容器关闭,这里是进不了shell的容器。
		- docker run -d --name nginx_web3 -p 80 rusiwillbeok/commit_test:rusi nginx -g "daemon off;" 
		-- 如果你想创建一个可以进入shell的容器
		docker run -itd --name nginx_web4 -p 80 rusiwillbeok/commit_test:rusi /bin/bash
		-- 查看正在运行的容器的端口映射
		- docker ps 
		-- 本地访问
		- host:port

	# 通过Dockerfile文件构建
		-- 创建Dockerfile文件
		参考：https://www.cnblogs.com/panwenbin-logs/p/8007348.html
		-- 使用docker build命令（-t 创建镜像的名字 . 代表当前目录）
			docker build 
			参考：https://www.runoob.com/docker/docker-build-command.html
			例：docker build -t 'runoob/ubuntu:v1' . 

		部分内容：
			FROM:镜像名[镜像：标签名]  要求：必须是已经存在的镜像，必须是基础镜像，必须是第一条非注释指令
			MAINTAINER： 指定作者的信息，一般包含所有者的名字和联系信息
			RUN（镜像构建过程中运行的）：指定镜像构建后执行的命令，每次构建都会创建一个中间镜像，如果你觉得你不会使用这些中间镜像，以在构建时指定--no-cache参数，如：docker build --no-cache
			EXPOSE 指定运行该镜像的容器使用的映射端口（可以指定多个），但是不会打开，还是需要通过run命令构建容器的时候自己输入。
			CMD:指容器启动时的默认行为，可以被覆盖。
			ENTRYPOINT：指容器启动时的默认行为（定义多个只会生效一个），启动时不可以被覆盖，除非指定 --entrypoint,(利用CMD和ENTRYPOINT的特性：使CMD定义参数，ENTRYPOINT定义命令)。
			ADD（两个参数：来源地址和目标地址）：将本地文件添加到容器中，tar类型文件会自动解压，来源地址：必须是构建目录的相对地址，目标地址：必须是绝对路径。它也可访问网络资源，但是并不推荐。
			COPY:和ADD的区别是：ADD带解压功能，COPY没有。
			VOLUME：一个卷可以存在于一个或多个容器的指定目录，该目录可以绕过联合文件系统，并具有以下功能：
					1 卷可以容器间共享和重用
					2 容器并不一定要和其它容器共享卷
					3 修改卷后会立即生效
					4 对卷的修改不会对镜像产生影响
					5 卷会一直存在，直到没有任何容器在使用它
			WORKDIR:设置工作目录，要使用绝对路径，不然工作路径会“很奇怪”。
				通过WORKDIR设置工作目录后，Dockerfile中其后的命令RUN、CMD、ENTRYPOINT、ADD、COPY等命令都会在该目录下执行。在使用docker run运行容器时，可以通过-w参数覆盖构建时所设置的工作目录
			ENV:设置环境变量（机算机在执行命令的时候是在环境变量找对应的命令的位置的，如果不正确设置环境变量就不能正确使用相应的命令。）->比如设置缓存的刷新时间
			USER: 指定镜像会以什么样的用户去运行，如果不指定，默认root
			ONBUILD：用于设置镜像触发器。
				创建自己的时候不会触发ONBUILD，但是，当所构建的镜像被用做其它镜像的基础镜像，该镜像中的触发器将会被触发。

		例如：
			# This my first nginx Dockerfile
			# Version 1.0

			# Base images 基础镜像
			FROM centos

			#MAINTAINER 维护者信息
			MAINTAINER tianfeiyu 

			#ENV 设置环境变量
			ENV PATH /usr/local/nginx/sbin:$PATH

			#ADD  文件放在当前目录下，拷过去会自动解压
			ADD nginx-1.8.0.tar.gz /usr/local/  
			ADD epel-release-latest-7.noarch.rpm /usr/local/  

			#RUN 执行以下命令 
			RUN rpm -ivh /usr/local/epel-release-latest-7.noarch.rpm
			RUN yum install -y wget lftp gcc gcc-c++ make openssl-devel pcre-devel pcre && yum clean all
			RUN useradd -s /sbin/nologin -M www

			#WORKDIR 相当于cd
			WORKDIR /usr/local/nginx-1.8.0 

			RUN ./configure --prefix=/usr/local/nginx --user=www --group=www --with-http_ssl_module --with-pcre && make && make install

			RUN echo "daemon off;" >> /etc/nginx.conf

			#EXPOSE 映射端口
			EXPOSE 80

			#CMD 运行以下命令
			CMD ["nginx"]

		Dockerfile的构建过程:
			1 从基础镜像中运行一个容器
			2 执行一条指令，对容器做出修改
			3 执行类似docker commit的操作，提交一个新的镜像层
			4 再基于刚提交的镜像运行一个新的容器
			5 执行 dockerfile的下一条指令，直到所有的指令都执行完毕
			ps: 1）docker build 会删除中间生成的容器，但是不会删除中间生成的镜像：这样的好处有：查找错误产生的位置。
				2）而且每一步的构建过程都会被缓存下来。如果不想使用缓存（比如存在apt-get的时候（希望更新最新版本））的话：docker build --no-cache 选项


-- docker的启动选项（linux下）

首先要知道：
	修改docker的配置文件，相当于在docker的启动选项后添加参数 可以通过 ps -ef | grep docker查看配置的信息
	每次配置相关信息之后要重启docker的服务（sudo service docker restart）
	docker 采用c/s模式，再输入命令的时候其实是通过客户端与服务器（docker的守护进程）通信，其实也是可以采用api接口进行访问的
其接口可通过unixsocket（默认）和socketfd及tcp/ip协议三种形式访问，接口设计谨遵restful风格. 
	-H  tcp://host:port
		unix:///path/to/socket
		fd:// orfd://socketfd           (//后面加个 *，因为文件后缀为sql，避免将后文全部注释了)

	守护进程的默认配置(知道即可)：-H unix://var/run/docker.sock	

然后：
	1.启动选项通过命令行修改
		docker -d [opions]  :选项有很多，设置较为灵活，参考百度

	2.修改其启动配置文件：
		docker的启动配置文件在：/ect/default/docker
			1.一般用于修改label选项，区别服务器名称
			2.令别的服务器可以连接本地docker(全0ip代表默认用自身ip进行绑定)
			配置信息如： DOCKER_OPTS='label name=docker_server1 -H tcp://0.0.0.0:2375'
			3.当配置上诉信息之后，此时的docker为远程服务，不可进行本地访问了，输入命令会提示不支持错误，
				- 你可以配置：export DOCKER_HOST="http://IP:port"环境变量（指定到本机），通过tcp连接的方式访问。
				- 再设置一下其配置值，之后就可以正常访问了：
				DOCKER_OPTS='label name=docker_server1 -H tcp://0.0.0.0:2375 -H unix:///path/to/socket'
			（配置之后都是需要重启的）
			
-- docker的远程连接（两台机器：A，B）
	1.修改A启动配置文件，令其可通过tcp链接（修改步骤参考：“docker的启动选项（linux下）”）
	2.B通过Api测试： curl http:/host:port/info
	3.B通过客户端进行访问：docker -H http://host:port 命令（例：info） 即可。
		-- 使用环境变量，避免总是输入ip端口,配置之后就可以像在本机一样进行访问了，如果需要修改回来，将其置空即可。
		export DOCKER_HOST="http://host:port"

	
-- docker网络链接(ubuntu)

	-- docker容器的网络基础
		- ifconfig->docker0 提供docker的网络链接
		- 一般来说网桥属于链路层（也就是加mac地址的），但是linux中是可以给虚拟网桥设置ip地址的，这是因为虚拟网桥是通用网络设备的一种，只要是网络设备就可以设置ip地址
		- 进而虚拟网桥有ip地址的话，linux便可以通过路由表或者ip表规则在网络层定位网桥，这就相当于拥有了一个虚拟网卡，而这个网卡的名字就是虚拟网桥的名字，也就是docker0
		- docker 会给每个容器分配唯一的ip mac地址 而且容器和docker0沟通会通过vethad*这个接口，当开启容器的时候可以通过网桥管理工具的命令（sudo brctl show）配合 ifconfig查看
		- 网桥管理工具 sudo apt-get install brideg-utils是需要自己安装管理的。

		- 可以自定docker0
			- sudo ifconfig docker0 192.168.200.1 netmask 255.255.255.0 修改默认的。

		- 使docker使用自定义的虚拟网桥：
			- 添加虚拟网桥： 
				sudo brctl addr name 
				sudo ifconfig name 192.168.200.1 netmask 255.255.255.0

			-  修改/etc/default/docker 中添加DOCKER_Ops的值
				DOCKER_Ops="-b=name"

	-- docker容器键的互联（在同一宿主机上默认允许所有的容器互联）
		-- 互相访问
			- 一般容器重启ip会变，为了避免服务受ip的影响，所以启动容器的时候有link选项。
				docker run -it --name rusi --link = cct1:web1 镜像名   
				此时，rusi ping cct1的别名web1就可以ping通 （也只有rusi可以ping的通）
		-- 拒绝访问
			- vim /etc/default/docker
			- 添加 DOCKER_OPTS ="--icc=false"

	-- 允许特定的容器间的链接(先阻断所有容器间的访问，除了使用link选项的容器)
		修改配置信息中的下面两项
		- --icc=false
		- --iptables=true
			- sudo iptables -L -n  查看iptables的配置信息（此时DROP在第一位，这是不合理的）
			- sudo iptables -F  重置iptables的配置（此时DROP在末位）
		- 启动容器的时候使用 --link



	-- docker容器与外部网络的连接

		-- ip_forward=1时代表数据转发开启了
			当开启docker后可通过：sudo sysctl net.ipv4.conf.all.forwarding 来查看；
			会显示：net.ipv4.conf.all.forwarding = 1
		-- iptables(是linux内核集成的包过滤防火墙系统)
			- 它孵化出层级系统：表-链-规则（ACCEPT、REJECT、DROP）
			- 其中 filter表中包含的链：INPUT FORWARD OUTPUT
			- sudo iptables -t filter -L -n 查看filter表的数据（-t 选项可以去掉，因为默认查的就是filter表的数据）

			- 当启动一个容器的时候，iptables的filter中会添加一条数据来允许外界和本机的访问，所以我们可以通过这一特点来修改其规则。
				- 修改访问规则，限制某一个ip：sudo iptables -Idocker -s 源ip -d 目的ip -p TCP（协议） --dport 80（端口映射） -j DROP(规则)
				- 允许的话 就修改规则即可。
			- 可参考：http://www.zsythink.net/archives/1199/

	-- docker容器的数据管理
	-- docker容器的数据卷
		- 数据卷：经过特殊设计的目录，可以绕过联合文件系统（UFS），为一个或者多个容器提供访问。
		- 数据卷的设计目的：在于数据的永久化，它完全独立与容器的生存周期，所以，docker不会再容器删除是删除其挂在的数据卷，也不会存在类似的垃圾手机机制，对容器引用的数据卷进行处理。
		- 数据卷的特点： 
			1.数据卷 可以在容器之间共享和重用
			2.对数据卷的修改会立马生效
			3.对数据卷的更新，不会影响镜像
			4.数据卷 默认会一直存在，即使容器被删除
			5.数据卷在容器启动时初始化，如果容器中使用的镜像在挂载点包含了这些数据，这些数据会拷贝到新初始化的数据卷中。

		-- 创建数据卷用于共享（可通过 inspect命令查看相关信息）:
		docker run -it -v ~/name:/data ubuntu /bin/bash    ~/name(本机访问地址) /data（容器访问地址）
		-- 创建数据卷并添加只读权限(该容器只能读取数据卷内容，不可修改)（可通过 inspect命令查看相关信息）
		docker run -it -v ~/name:/data:ro ubuntu /bin/bash
		-- 是可以使用dockerfile构建包含数据卷的镜像的
			VOLUME指令。
			- 此时创建的数据卷和通过run命令创建的数据卷是不同的：
				- 此时创建的数据卷是不能映射到本地文件目录的
				- 而且每一个以该镜像启动的新容器，数据卷所在位置是不一样的，其文件目录是docker自动创建的
				- 这时候我们只能通过数据卷容器，来实现容器间的数据共享。
		-- docker的数据卷容器
			- 定义：命名的容器挂在数据卷，其他容器通过挂载这个容器实现数据共享，挂在数据卷的容器，就叫做数据卷容器
			- 原理：数据卷容器挂载了一个本地目录，其它容器通过连接这个数据卷容器来实现数据共享
			-- 挂载数据卷容器的方法：
				通过 --volumes-from选项
				- docker run -it --name 容器名 --volumes-from 已经挂载了数据卷的容器 镜像名 /bin/bash
				例如：docker run -it --name dvt5 --volumes-from dvt4 ubuntu /bin/bash
			- 而且，有意思的是即使现在将dvt4这个容器删除了，也不会影响dvt5访问这个数据卷，因为容器在这里仅仅提供了数据卷传递的作用，只要这个数据卷一直都有容器在使用。
		-- docker数据卷的备份和还原
			- 启动新的容器用于执行备份命令
			docker run --volumes-from 需要备份的容器的名字 -v 指定备份文件希望存放的位置:容器中指定的目录位置:文件权限wr默认）--name 该容器名 镜像名 备份命令(压缩命令 保存的位置 文件本来所在的位置)
			例如：docker run --volumes-from dvt5 -v ~/backup:/backup:wr --name dvt10 ubuntu tar cvf /backup/dvt5.tar /datavolume1

	-- docker容器的跨主机连接
		- 参考：https://blog.csdn.net/fsx2550553488/article/details/80474773
		-- 网桥跨主机连接（不常用）

		-- 使用open vswitch实现跨主机容器连接（常用）

		-- 使用weave实现跨主机容器连接 




