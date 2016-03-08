//
//  NetWorkTool.h
//  tableView NSOperation 综合应用
//
//  Created by 苏子瞻 on 15/12/11.
//  Copyright © 2015年 苏子瞻. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JSONAnalisys)(id JsonObject, NSURLResponse *response);
typedef void(^AnalisysSuccess)(NSData *  data, NSURLResponse *  response);
typedef void(^AnalisysFluse)(NSError *  error);


@interface NetWorkTool : NSObject


+(instancetype)sharedNetworkTool;

// 网络请求的方法
// successBlock: 网络成功的回调
// fauseBlock: 网络失败的回调
-(void)getURLRequestWithUrlString:(NSString *)urlString successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock;



// 网络请求的方法 // 默认将服务器返回的数据当做json数据处理!
// JSONSuccessBlock: 网络成功的回调
// fauseBlock: 网络失败的回调
-(void)getURLRequestWithUrlString:(NSString *)urlString josnSuccessBlock:(JSONAnalisys)JSONSuccessBlock fause:(AnalisysFluse)fauseBlock;






// 带参数的GET请求
// 参数:参数都放在字典中!
// paramaters:参数字典!
-(void)GETURLRequestWithUrlString:(NSString *)urlString paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock;

// 带参数的POST网络请求
-(void)POSTURLRequestWithUrlString:(NSString *)urlString paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock;




// 动态获取文件类型!
// 返回值: 响应! 文件类型: response.MIMEType
-(NSURLResponse *)getFileTypeWithUrlString:(NSString *)urlString;






// 单文件 的请求体格式
// urlString :文件上传的网络接口!
// filePath: 需要上传的文件参数地址!
// fileKey: 服务器接收文件参数的 key 值!
// fileName :文件在服务器上保存的名称,如果传nil,默认是用建议的名称!
- (NSData *)getHttpBodyWithFilePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName;

// 单文件上传的网络请求
// urlString :文件上传的网络接口!
// filePath: 需要上传的文件参数地址!
// fileKey: 服务器接收文件参数的 key 值!
// fileName :文件在服务器上保存的名称,如果传nil,默认是用建议的名称!
// successBlock :成功回调!
// fauseBlock :失败回调!
-(void)POSTFileRequestWithUrlString:(NSString *)urlString FilePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock;




// 多文件上传+普通参数 的请求体格式
// fileKey: 服务器接收文件参数的 key 值!
// fileDict: 文件字典<key:文件路径=value:文件名称>
// paramaters : 普通参数字典<key:服务器接收参数的key值=value:参数内容>
-(NSData *)getHttpBodyWithFileKey:(NSString *)fileKey fileDict:(NSDictionary *)fileDict paramaters:(NSDictionary *)paramaters;

// 多文件上传的网络请求
// urlString :文件上传的网络接口!
// fileKey: 服务器接收文件参数的 key 值!
// fileDict: 文件字典<key:文件路径=value:文件名称>
// paramaters : 普通参数字典<key:服务器接收参数的key值=value:参数内容>
// successBlock :成功回调!
// fauseBlock :失败回调!
-(void)POSTMoreFileWithUrlString:(NSString *)urlString FileKey:(NSString *)fileKey fileDict:(NSDictionary *)fileDict paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock;


@end



