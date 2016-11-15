//
//  ViewController.m
//  socketAndLKDBHelperDemo
//
//  Created by m on 2016/11/15.
//  Copyright © 2016年 XLJ. All rights reserved.
//

#import "ViewController.h"
#import <SRWebSocket.h>
#import "SQliteModel.h"

@interface ViewController ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *socket;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController
- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *userID = @"12345";
    
    LKDBHelper *allHelper = [SQliteModel getUsingLKDBHelper];
    SQliteModel *model = [[SQliteModel alloc] init];
    //1.查询
    //1.1 删除所有的表
    [allHelper dropAllTable];
    
    //1.2 插入数据
    model.userID = @"1129";
    model.userName = @"我是锤锤";
    model.userPhone = @"18786642655";
    model.ptime = @"2016-11-15";
    
    [model saveToDB];
    //1.3 另一种插入方式
    model.userPhone = @"1399998888";
    [allHelper insertToDB:model];
    
    //1.4查询的方式
    /**
     * 第一个参数是查询的条件
     * orderBy:第二个参数是排序是以时间为降序
     * offset:0代表从第0个位置开始，比如在加载更多的时候会用到
     * count:0代表所有的，非0代表一共查询多少行数据
     */
    NSMutableArray *array = @[].mutableCopy;
    array = [SQliteModel searchWithWhere:[NSString stringWithFormat:@"userID=%@",userID] orderBy:@"ptime desc" offset:0 count:0];
    
    if (array.count>0) {
        //将查询到的数据保存到本地的数组中
        //这样看起来有没有很熟悉的感觉?是不是简单多了
        //多说一句，因为我这里并没有写的很详细。请在哪里需要用到的进行自己选择，千万不要看都不看就直接按照我的顺序来炒，那样是不行滴哟。
        //各种组合的查询我后面会给出参考的地址，有需要的请参考。
        self.dataSource = array;
    }
    //查询符合条件的条数
    NSInteger rowCount=[SQliteModel rowCountWithWhere:@"userID=2250"];
    NSLog(@"rowCount %ld",rowCount);
    
    //2.更新,带条件更新
    //根据userID来进行更新
    [SQliteModel updateToDB:model where:@{@"userID":model.userID}];

    
    //3.删除
    
   NSString * user=[allHelper searchSingle:[SQliteModel class] where:@{@"userPhone":@"12345678911"} orderBy:nil];
    BOOL ishas=[allHelper isExistsModel:user];
    if (ishas) {
        [allHelper deleteToDB:user];
    }
    
    //删除多条
    BOOL isDeleteMore=[allHelper deleteWithClass:[SQliteModel class] where:@"userName=1239"];
    if (isDeleteMore) {
        NSLog(@"符合条件的都被删除");
    }
    
}

/**
 *  Socket建立连接
 */
- (void)connectSocket
{
    //此地址不代表真实地址
    NSString *url = @"xsp://push.lala.com:8888";
    //初始化
    self.socket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:url]];
    //设置代理
    self.socket.delegate = self;
    //打开socket连接
    [self.socket open];
}

/**
 *  Socket断开连接
 *  分为服务器断开和客户端断开
 *  此处为客户端断开
 */
- (void)discononectSocket
{
    //关闭socket连接
    [self.socket close];
    self.socket = nil;
    self.socket.delegate = nil;
}

#pragma mark -- SocketDelegate
/**
 *  收到服务器的消息
 *
 *  @param webSocket socket
 *  @param message  收到服务器的消息，有可能是字符串，或是NSData数据
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSError *error = nil;
    NSString *receiveMessage = (NSString *)message;
    
    //如果数据不能解析，很有可能是后台传的时候有tab键或是空格，找后台排查，或者就用字符替换掉这些多余的字符
    NSData *data = [receiveMessage dataUsingEncoding:NSUTF8StringEncoding];
    
    //NSJSONReadingAllowFragments不管外层的类型是什么
    NSDictionary *responseObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
     NSString *type = responseObj[@"type"];
    
    //这里的代码不准确，主要是根据后台的返回类型来处理
    NSUInteger index = [NSString stringWithFormat:@"%@",type];

    switch (index) {
        case 0:
        {
            //心跳报文
        }
            break;
            
        case 1:
        {
            //推送的消息1,处理数据，保存到数据库
            
            //获取到的数据为字典
            NSDictionary *dict = responseObj[@"data"];
            //数据转为模型
            SQliteModel *firstModel = [SQliteModel yy_modelWithDictionary:dict];
            
            //保存模型
           BOOL isSaved = [firstModel saveToDB];
            
        }
            break;
            

        case 2:
        {
            //推送的消息2,处理数据，保存到数据库
        }
            break;
            

        default:
            break;
    }
    
}

/**
 *  Socket建立连接成功
 *
 *  @param webSocket 已经打开socket成功
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    //连接成功之后可以给服务器发送数据，主要数据是服务器需要的参数
}

/**
 *  Socket关闭连接
 *
 *  @param webSocket <#webSocket description#>
 *  @param code      描述
 *  @param reason    原因
 *  @param wasClean  <#wasClean description#>
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    self.socket.delegate = nil;
    self.socket = nil;
    
    NSLog(@"socket close原因: %@,",reason);
}

/**
 *  Socket连接失败,客户端断网会调用
 *
 *  @param webSocket <#webSocket description#>
 *  @param error     失败原因
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"客户端网络异常:%@",error);
}

//暂未使用到
- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}




@end
