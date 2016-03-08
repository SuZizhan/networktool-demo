//
//  NetWorkTool.m
//  tableView NSOperation 综合应用
//
//  Created by 苏子瞻 on 15/12/11.
//  Copyright © 2015年 苏子瞻. All rights reserved.
//

#import "NetWorkTool.h"
#define kBoundary @"boundary"


@implementation NetWorkTool

+(instancetype)sharedNetworkTool
{
    static id _instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}


// 网络请求的方法
// successBlock: 网络成功的回调
// fauseBlock: 网络失败的回调
-(void)getURLRequestWithUrlString:(NSString *)urlString successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (successBlock) {
                successBlock(data,response);
            }
        }else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];

}

// 网络请求的方法 // 默认将服务器返回的数据当做json数据处理!
// JSONSuccessBlock: 网络成功的回调
// fauseBlock: 网络失败的回调
-(void)getURLRequestWithUrlString:(NSString *)urlString josnSuccessBlock:(JSONAnalisys)JSONSuccessBlock fause:(AnalisysFluse)fauseBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"%@",[NSThread currentThread]);
        if (data && !error) {
            
               id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (JSONSuccessBlock) {
                    JSONSuccessBlock(obj,response);
                }
            });
        }
        else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
}



// 带参数(如账户名 密码)的GET请求
// 参数:参数都放在字典中!
// paramaters:参数字典!
-(void)GETURLRequestWithUrlString:(NSString *)urlString paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock
{
    if (paramaters) {
        // GET 请求的参数都拼接在URL中!
        // 遍历参数字典,取出所有的参数,拼接!
        NSMutableString *parameter = [NSMutableString string];
        [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [parameter appendFormat:@"%@=%@&",key,obj];
            
        }];
      urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"?%@",parameter]];
        //删除最后一个&符号
        urlString = [urlString substringToIndex:urlString.length -1];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (successBlock) {
                successBlock(data,response);
            }
        }else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
}


// 带参数(如账户名 密码)的POST请求
-(void)POSTURLRequestWithUrlString:(NSString *)urlString paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock
{
   
    NSData *body = [NSData data];
    //参数不拼接在urlString中
    
    if (paramaters) {
        // GET 请求的参数都拼接在URL中!
        // 遍历参数字典,取出所有的参数,拼接!
        NSMutableString *parameter = [NSMutableString string];
        [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [parameter appendFormat:@"%@=%@&",key,obj];
            
        }];
        //删除最后一个&符号
        NSString *bodyString = [NSString string];
        bodyString = [bodyString substringToIndex:parameter.length - 1];
        
        body = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    request.HTTPMethod = @"POST";
    request.HTTPBody = body;
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (successBlock) {
                successBlock(data,response);
            }
        }else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];

}



// 动态获取文件类型!
// 返回值: 响应! 文件类型: response.MIMEType
-(NSURLResponse *)getFileTypeWithUrlString:(NSString *)urlString
{
    urlString = [NSString stringWithFormat:@"file://%@",urlString];
    //    将中文转成百分数
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:NULL];
    
    // 文件的大小
    // 文件的格式
    // 文件的建议名称
    //  NSLog(@"response:%lld %@ %@",response.expectedContentLength,response.suggestedFilename,response.MIMEType);
    
    return response;
}




// 封装单文件上传的数据格式
// filePath :需要上传的文件地址!
// fileKey: 服务器接收文件参数的 key 值!
// fileName: 文件在服务器上保存的名称!
-(NSData *)getHttpBodyWithFilePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName
{
    NSMutableData *data = [NSMutableData data];
    NSURLResponse *response = [self getFileTypeWithUrlString:filePath];
    NSString *fileType = response.MIMEType;
    // 如果外界没有传入文件名称,就是用建议的文件名!
    if (!fileName) {
        fileName = response.suggestedFilename;
    }
    //设置上边界的格式
    NSMutableString *headerStrM = [NSMutableString string];
    [headerStrM appendFormat:@"--%@\r\n",kBoundary];
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",fileKey,fileName];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    
    //将上边界添加到请求体中
    [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    //请求体中添加文件内容
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    //设置下边界的格式
    NSMutableString *footerStrM = [NSMutableString string];
    [footerStrM appendFormat:@"\r\n--%@--\r\n",kBoundary];
    
    //将下边界的添加到请求体中
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    return data;
}


// 单文件上传的网络请求
// urlString :文件上传的网络接口!
// filePath: 需要上传的文件参数地址!
// fileKey: 服务器接收文件参数的 key 值!
// fileName :文件在服务器上保存的名称,如果传nil,默认是用建议的名称!
// successBlock :成功回调!
// fauseBlock :失败回调!
-(void)POSTFileRequestWithUrlString:(NSString *)urlString FilePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock
{
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self getHttpBodyWithFilePath:filePath fileKey:fileKey fileName:fileName];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (successBlock) {
                successBlock(data,response);
            }
        }else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];
    
    
}



// 多文件上传+普通参数 的请求体格式
// fileKey: 服务器接收文件参数的 key 值!
// fileDict: 文件字典<key:文件路径=value:文件名称>
// paramaters : 普通参数字典<key:服务器接收参数的key值=value:参数内容>
-(NSData *)getHttpBodyWithFileKey:(NSString *)fileKey fileDict:(NSDictionary *)fileDict paramaters:(NSDictionary *)paramaters
{
    NSMutableData *data = [NSMutableData data];
    
    [fileDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *filePath = key;
        NSString *fileName = obj;
        
        NSURLResponse *response = [[NetWorkTool sharedNetworkTool] getFileTypeWithUrlString:filePath];
       
        NSMutableString *headerStrM = [NSMutableString string];
        [headerStrM appendFormat:@"--%@\r\n",kBoundary];
        [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",fileKey,fileName];
        [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",response.MIMEType];
        
        //将上边界添加到请求体中
        [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
        //请求体中添加文件内容
        NSData *fileData = [NSData dataWithContentsOfFile:filePath];
        [data appendData:fileData];
    }];
    //遍历参数字典
    [paramaters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *paramaterKey = key;
        NSString *paramaterValue = obj;
        
        // 普通参数的上边界
        NSMutableString *headerStrM = [NSMutableString string];
        [headerStrM appendFormat:@"\r\n--%@\r\n",kBoundary];
        // name=username:服务器接收普通参数的 key 值!
        [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n",paramaterKey];
        [data appendData:[headerStrM dataUsingEncoding:NSUTF8StringEncoding]];
        
        // 第一个普通参数内容
        [data appendData:[paramaterValue dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    //设置下边界的格式
    NSMutableString *footerStrM = [NSMutableString string];
    [footerStrM appendFormat:@"\r\n--%@--\r\n",kBoundary];
    //将下边界的添加到请求体中
    [data appendData:[footerStrM dataUsingEncoding:NSUTF8StringEncoding]];
    
    //
     return data;
}

// 多文件上传的网络请求
// urlString :文件上传的网络接口!
// fileKey: 服务器接收文件参数的 key 值!
// fileDict: 文件字典<key:文件路径=value:文件名称>
// paramaters : 普通参数字典<key:服务器接收参数的key值=value:参数内容>
// successBlock :成功回调!
// fauseBlock :失败回调!
-(void)POSTMoreFileWithUrlString:(NSString *)urlString FileKey:(NSString *)fileKey fileDict:(NSDictionary *)fileDict paramaters:(NSDictionary *)paramaters successBlock:(AnalisysSuccess)successBlock fause:(AnalisysFluse)fauseBlock
{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    request.HTTPBody = [self getHttpBodyWithFileKey:fileKey fileDict:fileDict paramaters:paramaters];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data && !error) {
            if (successBlock) {
                successBlock(data,response);
            }
        }else
        {
            if (fauseBlock) {
                fauseBlock(error);
            }
        }
    }] resume];

}




@end
