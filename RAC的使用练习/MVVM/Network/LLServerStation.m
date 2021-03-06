//
//  LLServerStation.m
//  BaiSiBuDeJie
//
//  Created by 迦南 on 2017/7/21.
//  Copyright © 2017年 ray. All rights reserved.
//

#import "LLServerStation.h"
#import <CommonCrypto/CommonDigest.h>

static LLServerStation *_instance = nil;
static NSString * const salt = @"gn1002015";

@interface LLServerStation ()

@property (nonatomic, weak) AFHTTPSessionManager *manager;
@end

@implementation LLServerStation

- (AFHTTPSessionManager *)manager {
    if (nil == _manager) {
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
         mgr.requestSerializer = [AFJSONRequestSerializer serializer];
        
        AFHTTPResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializer];
        responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        mgr.responseSerializer = responseSerializer;
        
        _manager = mgr;
    }
    return _manager;
}

+ (instancetype)shareInstance {
    
    LLServerStation *instance = [[self alloc] init];
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:zone] init];
    });
    return _instance;
}

// 取消请求
- (void)cancelLoadData {

    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
}


- (void)loadDataWithSuccessBlock:(void(^)(id responseObject))successBlock errorBlock:(void(^)(NSError *error))errorBlock {
    
    NSString *url = @"https://www.yunke.com/interface/main/home";
    
    NSDictionary * params = @{@"city":@"中国",
                              @"cityId":@0,
                              @"condition":@"35,33,32,35,34",
                              @"teacherSeach":@"1000,1000,1000"
                              };
    NSString *version = [self Version];
    
    //   获取当前的时间
    int liTime = [self getDateByInt];
    NSString *keymd5 = [self md5ForParamas:params time:liTime];
    NSDictionary *myparamses =@{
                                @"u":@"i",
                                @"v":version,
                                @"time":@(liTime),
                                @"params":params,
                                @"key":keymd5
                                };

    [self.manager GET:url parameters:myparamses progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
}

- (NSString *)Version {
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:string];
    NSString *version = [dic objectForKey:@"CFBundleVersion"];
    return version;
}

// 获取当前时间
- (int)getDateByInt
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [dateFormat dateFromString:[dateFormat stringFromDate:[NSDate date]]];
    NSTimeInterval dateInterval = [date timeIntervalSince1970];
    int liDate = (int) dateInterval;
    return liDate;
}

// 参数md5 key值
- (NSString *)md5ForParamas:(NSDictionary *)paramas time:(int) aiTime
{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramas options:NSJSONReadingAllowFragments error:nil];
    // NSJSONReadingAllowFragments : 使用这个
    // NSJSONWritingPrettyPrinted 会有\n，不需要
    NSString *jsonParserString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    NSString *myString = [NSString stringWithFormat:@"%@%d%@",jsonParserString,aiTime, salt];
    
    NSString *keyMD5 = [self getMd5_32Bit_String:myString];
    NSString *keymd5 = [self getMd5_32Bit_String:keyMD5];
    
    
    return keymd5;
}

//  MD5
- (NSString *)getMd5_32Bit_String:(NSString *)srcString
{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

@end
