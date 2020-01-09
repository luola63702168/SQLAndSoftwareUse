1.绝对路径一般都是/开头的

2.cd ~ 是用户所在目录，也就是家目录；/ 是根目录 - 是返回到上一次的工作目录，. 代表当前文件夹；.. 代表上一级文件夹。

2.在同一目录下面无论是文件还是目录是不可以有一样的

3.ctrl a 回到命令行首 ctrl e 回到命令行尾。

4.拖拽文件到shell中的时候会直接出现路径的。

3.mkdir -p a2/b2/c2  -p代表可以创建多级目录

4.rm -r a1 a2 -r代表可以删除文件夹
	也可以a1 a2=a*

6.ls 查看当前目录中的文件（-a:显示隐藏文件；-l详细显示文件；-h显示文件大小）
	第一段表示文件所有者对此文件的操作权限
	第二段表示文件所有者所在组对些文件的操作权限
	第三段表示除上述两种外的任何用户/组对此文件的操作权限

5.- 后面可以接的字母可以不必全带 - 例：ls -lha 或者 rm -r -f

6.rm -rf *（该目录下所有东西全部删除且不用确认）

8.复制文件: cp ~/Documents/readme.txt ./readme.txt 

10.cat -b -n (-b标识行数，-n包括空行)

11.grep -vni  "as" a.txt 搜索这个文本a中不包括as的数据，显示行数且不区分大小写。（""中可以是正则）

12，echo  hello >> a.txt 将hello附加到a文件中，如果不存在就会创建（> 是覆盖）

13.shutdown -r重启，down后可跟时间（比如： now）

13.reboot 重启命令

14. more 类似cat 但是是全屏展示，且支持vi命令。
	包括但不限于：
		space，z 		向下翻页
		b，ctrl+b       向上翻页 
		Enter 　　   	向下滚动 1 行
		= 　　　　   	显示当前行号
		v　　　　　 		用vi编辑器打开当前内容
		:f 　　          显示当前文档文件名与当前行号
		d，ctrl+D       向下翻 K 行，默认k=11
		q，Q            退出more
		ctrl+L          类似于清屏
		h               显示快捷键帮助

14. | 管道命令，通常配合more和grep命令使用

15.ifconfig 查看网卡信息 win是ipconfig

16 ping 检测网络通信 跟ip地址

16.ctrl c 结束命令

17.sudo 超管命令 

18.man是帮助命令

19.date时间 

20.cal -y（一年日历，不加-y是当月的）

21.df -h 查看磁盘空间 

22.du -h 查看当前目录大小（可接文件或目录，-h人性化显示）

23.ps 显示当前打开的进程 ps aux 看到详细进程有哪些

24.top 可以对进程实时排序（q退出）

25.kill -9 进程代号（-9代表强行杀进程）

26.who 可以查看所有的登录账户及时间 

26.whoami 问问自己是谁

26.whereis 查看文件的位置

27.find Desktop/ -name "*1*" 查找文件 若不接路径即是当前文件夹，支持正则

28.ln -s /etc/issue /tmp/issue.soft ：创建/etc/issue文件的软链接/tmp/issue.soft，去掉-s为创建硬链接。
	硬连接：删除源文件，无影响；软连接会失效。
29..sudo apt install htop（可自定义软件源）

30.ldd 查看依赖库  

31.alias 设置命令的别名，例:alias lx=ls -l

32.fc-list :lang=zh 查看系统自带的中文字体

33.tail -f run.log  查看进程输出的后面几行的数据，它还是一个等待的过程，不会自己出去。

34.echo 控制台输出信息

35.history：用于显示历史记录和执行过的指令命令。

35.curl是一种命令行工具，作用是发出网络请求，然后得到和提取数据，显示在"标准输出"（stdout）上面。

36. 查看端口占用：netstat -apn | grep 8000

37.刷新终端环境:source ~/.bashrc  

38.locate 配合数据库查看文件位置。

39.nc -u 路径  连接socket

40. sudo status 进程名 查看进程运行状态

41. sudo service 进程名 start  stop  restart  启动 停止 重启服务命令

42.openssl  生成密匙对

43 wget 网络下载命令

44.ctrl+shift+t , 在同一个窗口中打开了另一个终端；Alt+n,对应的就会切换到第n个终端。


37.关于用户、组和权限等
	0.id 账户名 可以知道账户具有的权限 uid用户代号和gid组代号

	1.usermod 知道主组passwd和副组group 

	2.groupadd（del） 添加（删除）组
	  	cat /etc/group确定添加组没

	3.useradd -m -g添加用户，m必要，-g后接组 再接用户名 sudo useradd -m -g dev luola（del）

	5.sudo passwd luola 修改用户密码



	6.和给用户添加组权限 sudo usermod -G dev luola -g是附加主组权限

	7.sudo usermod -s /bin/bash luola（更改用户的shell权限默认dash改为bash方便win使用解决乱码）

	8.which 查看命令所在位置是在哪 bin是二进制可执行文件 sbin是指系统的二进制可执行文件

	9.su是切换用户，su - luola（带目录切换），su  root权限

	10.sudo chgrp -R python python学习/ 改变文件所属组（-R是子目录同等操作）

	11.chmod -R 754 文件/目录（-R同上）修改文件/目录权限

	12.sudo chown caiyun python学习/改变文件所属用户

关于ssh：ssh username@IP  
	1.ssh端口号是22
	2.需要下载ssh客户端
	3.可设置免密登陆（两个秘匙）
	4.可设置别名代替端口user@ip
	5.推送代码：scp ./xx.py username@IP:~/

关于压缩和解压缩
	tar命令（常用）
	  打包：tar czvf filename.tar dirname
	  解包：tar zxvf filename.tar

	  压缩：tar zcvf filename.tar.gz dirname
	  压缩多个文件：tar zcvf filename.tar.gz dirname1 dirname2 dirname3.....
	  解压：tar zxvf filename.tar.gz

	gz命令
	  解压1：gunzip filename.gz
	  解压2：gzip -d filename.gz
	  压缩：gzip filename .tar.gz 和 .tgz
	      解压：tar zxvf filename.tar.gz
	      压缩：tar zcvf filename.tar.gz dirname
	      压缩多个文件：tar zcvf filename.tar.gz dirname1 dirname2 dirname3.....
	      
	bz2命令
	  解压1：bzip2 -d filename.bz2
	  解压2：bunzip2 filename.bz2
	  压缩：bzip2 -z filename.tar.bz2

	       解压：tar jxvf filename.tar.bz2
	       压缩：tar jcvf filename.tar.bz2 dirname
	bz命令
	    解压1：bzip2 -d filename.bz
	    解压2：bunzip2 filename.bz.tar.bz

	       解压：tar jxvf filename.tar.bz
	z命令
	    解压：uncompress filename.z
	    压缩：compress filename
	        .tar.z
	          解压：tar zxvf filename.tar.z
	          压缩：tar zcvf filename.tar.z dirname

	zip命令（常用）
	    
	    解压：unzip filename.zip
	    压缩：zip filename.zip dirname

	补充：-C解压到指定路径（均适用）
		例：tar -zxvf py.tar.gz -C /home/python/Desktop/ll/
		
Linux中的标准输入输出
	标准输入0    从键盘获得输入 /proc/self/fd/0 
	标准输出1    输出到屏幕（即控制台） /proc/self/fd/1 
	错误输出2    输出到屏幕（即控制台） /proc/self/fd/2 

	/dev/null代表linux的空设备文件，所有往这个文件里面写入的内容都会丢失，俗称“黑洞” 

	1、2>/dev/null意思就是把错误输出到“黑洞” 

	2、>/dev/null 2>&1默认情况是1，也就是等同于1>/dev/null 2>&1。意思就是把标准输出重定向到“黑洞”，还把错误输出2重定向到标准输出1，也就是标准输出和错误输出都进了“黑洞” 

	3、2>&1 >/dev/null意思就是把错误输出2重定向到标准出书1，也就是屏幕，标准输出进了“黑洞”，也就是标准输出进了黑洞，错误输出打印到屏幕 
	关于这里”&”的作用，我们可以这么理解2>/dev/null重定向到文件，那么2>&1，这里如果去掉了&就是把错误输出给了文件1了，用了&是表明1是标准输出。


另外：
1.使用终端打开程序后，可以新建终端操作命令。或者是./pycharm.sh& 加个&就可以解决了
2.快捷键打开终端：
	ctrl shift t 同一个窗口多开一个终端
	ctrl alt t 空白页开一个窗口




