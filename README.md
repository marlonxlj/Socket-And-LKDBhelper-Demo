##socketket与lkdbhelper来处理数据

###客户需求：
当我们有需要从自己的后台推送消息给我们的用户时，用户需要实时的接收到来自我们的推送消息。前提是没有使用第三方的推送框架，那么这个使用websocket来接收消息，app端把接收到的消息存储在本地的数据库，让我们直接从数据库去读取数据。

####``SocketRocket``是facebook基于socket进行的二次封装。下面是它的下载地址:

[facebook/SocketRocket](https://github.com/facebook/SocketRocket.git)

####``LKDBHelper-SQLite-ORM``这个第三方库，全自动的插入,查询,更新,删除。 是对`sqlite`的封装，使开发者不必关心sqlite复杂的语句。这个是github的下载地址:

[li6185377/LKDBHelper-SQLite-ORM](https://github.com/li6185377/LKDBHelper-SQLite-ORM.git
)

从上面的需求中可以分析出做的事情，有2件事需要做。

##一、Socket连接获取到后台推送的数据


##二、把接受到的信息存储到本地的数据库中

>在准备数据库之前需要了解怎么做呢？
>
>1.首先是数据模型
>
>2.把数据转换成模型存储数据库


>如果有什么问题请在下方留言，也可以直接Email:marlonxlj@163.com


















