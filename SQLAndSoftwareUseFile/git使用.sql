0，sudo apt-get install git
1，工作区为整个文件夹，暂存区为git的版本库也就是.git文件。
1，git init  （初始化，在该文件夹里建立新仓库）撤销的话，就是删除.git文件夹就可以了。
2，使用git add code.txt放入暂存区（）可以跟目录名也可以是文件名（多个一起也可以）（在删除情况下，rm和add同等效果）。
3，git add 文件夹/     添加整个文件夹及内容
4，git add * 文件类型  添加目录中所有此文件类型的文件
3，git commit -m '版本的说明信息 '，来创建一个新的版本。（它只会提交暂存区中的内容）
3，git log 查看版本记录（后接文件名）。（q退出记录页）
4，git log --pretty=oneline （简短的查看版本记录）
4，git reset --hard HEAD^ 回退一个版本（HEAD~2 回退两个版本），后接版本号的话，还可以直接去到版本号对应的版本那里，另外，这个版本针对的是工作区中所有的文件，而不是单纯的某一个文件。
5，git reflog 查看操作日志
6，git status 查看工作区文件状态
7，git checkout -- 文件名 撤销该文件工作区的改动，(还未在暂存区)
7，git reset HEAD 文件名 ， 重置（取消）该文件的暂存区。
8，git diff HEAD -- 文件名  （对比工作区（工作区中得有文件）和版本库（也就是暂存区）文件的不同，文件内容中 -号代表修改前版本库的 +号代表修改后工作区的）
9，git diff HEAD HEAD^ -- code.txt （对比版本区中的文件名和其上一个版本的区别）
10，git branch  查看多少分支
11，创建并切换到这个分支：git checkout -b 分支名
12，切换分支：git checkout 分支名 
14，删除分支：git branch -d 分支名 
13，快速合并分支：git merge 分支名 （合并某分支到当前分支）。
	- 快速合并的前提是：分支上有提交而主分支上没有提交记录。

15，git status 还可以查看冲突
	- 冲突一般因为主分支和分支同时修改了同一个文件，然后执行合并时出现冲突，冲突一般手动解决（vi打开该文件，然后该删的删，该留的留），然后再次提交。
	- 此时log有三条记录：一个是主分支提交，一个是分支提交，一个是解决冲突提交。
16，git log --graph --pretty=oneline 可查看完成的分支冲突

16，分支管理策略：
- 普通的快速合并时，虽然有分支修改某个文件的信息，但是当合并之后，会没有相关分支的操作信息，感觉就像修改是在主分支上修改的一样。可通过 git log --pretty=oneline --graph 命令查看。
- 所以为了保留这些信息就有了分支管理策略。
	- 情况1：系统帮我们做。
	- 新建文件合并，当执行快速合并后，按照提示的操作好之后（在框中 写好备注没然后做一次新的提交）（具体操作为：写好备注，ctrl+x，y）。
	- 系统会自动的帮我们建立好分支信息。此时这个操作就为分支管理策略，只不过这是git帮我们做的分支管理策略
	- 情况2:禁用分支的快速合并。
	- 有时候我们能执行快速合并，但是我们想禁用快速合并，这样就可以利用分支管理策略在分支合并的时候，和上面一样做一次新的提交。
	- 在主分支上合并分支的时候使用：git merge --no-ff -m '备注'  分支名  
	- 来禁用分支的快速合并，使用分支管理策略


19，处理紧急bug
	- git stash  接到紧急任务时，保存工作现场。
	- 然后新建一个分支区解决问题，在回到主分支，使用“分支管理策略”合并分支，然后删除修复bug的那个分支，在回到之前的那个分支。
	- git stash list 查看工作现场。
	- git stash pop 恢复工作现场

20，如何在linux生成github的公钥？
	- 打开家目录中的.gitconfig文件，（编辑好自己的）
	- ssh-keygen -t rsa -C 'll63702168@qq.com'
	- /home/python/.ssh/id_rsa.pub 这个文件就是了

21 克隆项目
	- git  clone  ssh协议的下载链接，
	- 随后便会克隆到当前目录下了。
	- ps: github是以仓库为单位下载的。
	
22 git push origin  分支名  推送分支
23，git branch --set-upstream-to=origin/分支名  设置当前分支跟踪远程分支名 （当跟踪时，再次推送分支的时候就可以直接用 git push 了）
24 git pull origin 分支名  拉取远程分支上的代码。
25，在工作中一般 我们只是把代码下载到本地，然后新建一个分支做这个某一项功能的开发，我们也许会跟踪这个项目，但是提交和合并并不是我们应该做的事情，当提交到远程上面的时候，同事可能会下载我们的代码，容易出现测试错误，当
我们合并到主分支的时候，便是真正的上线，没有经过项目经理及测试，我们并不能保证代码的稳定性。
26 另外，我们合并分支的时候，必须要保证主分支的代码和远程上的是一样的，要不然会合并不成功的。


