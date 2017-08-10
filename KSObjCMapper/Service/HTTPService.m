//
//  HTTPService.m
//
//  Created by Ashish Sharma on 30/05/15.
//  Copyright (c) 2015 Konstant Info. All rights reserved.
//

#import "HTTPService.h"

@interface HTTPService () {
    
    /**
     *  array that holds all running data tasks
     */
    NSMutableArray *arrayRunningTasks;
}

/**
 *  Call this to set HTTP headers for request
 *
 *  @param headers HTTP headers
 */
- (void) setHeaders:(NSDictionary*) headers;

/**
 *  Call this to convert params in raw json format
 *
 *  @param params params to post
 */
- (void) addQueryStringWithParams:(NSDictionary*) params;

@end

@implementation HTTPService

#pragma mark - Designated Initializer

- (id)initWithBaseURL:(NSURL*) baseURL andSessionConfig:(NSURLSessionConfiguration*) config
{
    self = [super init];
    
    if (self)
    {
        NSAssert(baseURL, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"baseURL can't be nil",__PRETTY_FUNCTION__]));
        
        httpBaseURL = [baseURL absoluteString];
        
        if (config)
            httpSessionManager = [[AFHTTPSessionManager alloc]
                                  initWithBaseURL:baseURL sessionConfiguration:config];
        else
            httpSessionManager = [[AFHTTPSessionManager alloc]
                                  initWithBaseURL:baseURL sessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        if (_shouldUseSecurityPolicy) {
            AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
            httpSessionManager.securityPolicy = securityPolicy;
        }
        
        arrayRunningTasks = [[NSMutableArray alloc] init];
    }
    
    return self;
}

#pragma mark - Super Class Methods

- (id)init
{
    self = [super init];
    
    if (self)
    {
        httpBaseURL = @"https://jsonplaceholder.typicode.com/posts/1";
        httpSessionManager = [[AFHTTPSessionManager alloc]
                              initWithBaseURL:[NSURL URLWithString:httpBaseURL]];
        
        httpSessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        arrayRunningTasks = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    httpSessionManager = nil;
}

#pragma mark - Instance Methods (Private)

- (void) setHeaders:(NSDictionary*) headers
{
    if (headers != nil)
    {
        NSArray *allHeaders = [headers allKeys];
        
        for (NSString *key in allHeaders)
        {
            [httpSessionManager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
        }
    }
}

- (void) addQueryStringWithParams:(NSDictionary*) params
{
    [httpSessionManager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, NSDictionary *parameters, NSError *__autoreleasing *error) {
        __block NSMutableString *query = [NSMutableString stringWithString:@""];
        
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&err];
        NSMutableString *jsonString = [[NSMutableString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        query = jsonString;
        
        return query;
    }];
}

- (void)addTask:(NSURLSessionDataTask*) dataTask {
    
    if (![arrayRunningTasks containsObject:dataTask]) {
        [arrayRunningTasks addObject:dataTask];
    }
}

- (void)removeTask:(NSURLSessionDataTask*) dataTask {
    
    if ([arrayRunningTasks containsObject:dataTask]) {
        [arrayRunningTasks removeObject:dataTask];
    }
}

#pragma mark - Instance Methods

- (NSURLSessionDataTask*) startRequestWithHttpMethod:(kHttpMethodType) httpMethodType
                                     withHttpHeaders:(NSMutableDictionary*) headers
                                     withServiceName:(NSString*) serviceName
                                      withParameters:(NSMutableDictionary*) params
                                         withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    
    
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
    
    NSString *serviceUrl = [httpBaseURL stringByAppendingFormat:@"%@",serviceName];
    
    if ([serviceName containsString:GOOGLE_PLACES_API]) {
        serviceUrl = serviceName;
    }
    
    NSLog(@"URL :%@",serviceUrl);
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSLog(@"Time zone : %@",tzName);
    
    if (headers == nil)
    {
        NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Accept",@"application/json",@"Content-Type",tzName,@"timezone",nil];

        [self setHeaders:headers];
    }
    else
    {
        [headers setObject:@"application/json" forKey:@"Accept"];
        [headers setObject:@"application/json" forKey:@"Content-Type"];
        [headers setObject:tzName forKey:@"timezone"];

        [self setHeaders:headers];
    }
    
    
    NSLog(@"headers = %@",headers);
    
    if (params != nil)
        [self addQueryStringWithParams:params];
    
    switch (httpMethodType)
    {
        case kHttpMethodTypeGet:
        {
            NSURLSessionDataTask *dataTask =  [httpSessionManager GET:serviceUrl
                                                           parameters:params
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                  
                                                                  if (success != nil)
                                                                      success(task,responseObject);
                                                              }
                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  
                                                                  if (failure != nil)
                                                                      failure(task,error);
                                                              }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
        case kHttpMethodTypePost:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager POST:serviceUrl
                                                           parameters:params
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                  
                                                                  if (success != nil)
                                                                      success(task,responseObject);
                                                              }
                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  
                                                                  if (failure != nil)
                                                                      failure(task,error);
                                                              }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        
        }
            break;
        case kHttpMethodTypeDelete:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager DELETE:serviceUrl
                                                             parameters:params
                                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                    
                                                                    if (success != nil)
                                                                        success(task,responseObject);
                                                                }
                                                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                    
                                                                    if (failure != nil)
                                                                        failure(task,error);
                                                                }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
        case kHttpMethodTypePut:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager PUT:serviceUrl
                                                          parameters:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 
                                                                 if (success != nil)
                                                                     success(task,responseObject);
                                                             }
                                                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 
                                                                 if (failure != nil)
                                                                     failure(task,error);
                                                             }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
            
        default:
            break;
    }
}

- (NSURLSessionDataTask*) startMultipartFormDataRequestWithHttpHeaders:(NSMutableDictionary*) headers
                                                       withServiceName:(NSString*) serviceName
                                                        withParameters:(NSMutableDictionary*) params
                                                          withFileData:(NSArray*) files
                                                           withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                           withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
    
    NSString *serviceUrl = [httpBaseURL stringByAppendingPathComponent:serviceName];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSLog(@"Time zone : %@",tzName);
    
    if (headers == nil)
    {
        //NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"multipart/form-data",@"Content-Type",nil];

        [self setHeaders:headers];
    }
    else
    {
        //[headers setObject:@"multipart/form-data" forKey:@"Content-Type"];
        
        [self setHeaders:headers];
    }
    
    
    NSURLSessionDataTask *dataTask = [httpSessionManager POST:serviceUrl
                                                   parameters:params
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        for (NSData *fileData in files)
                                        {
                                            [formData appendPartWithFileData:fileData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
                                        }
                                    }
                                                     progress:nil
                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                          
                                                          if (success != nil)
                                                              success(task,responseObject);
                                                      }
                                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          
                                                          if (failure != nil)
                                                              failure(task,error);
                                                      }];
    
    if (dataTask != nil) {
        
        [self addTask:dataTask];
        
        return dataTask;
    }else {
        return nil;
    }
}

- (NSURLSessionDataTask*) startMultipartZipFormDataRequestWithHttpHeaders:(NSMutableDictionary*) headers
                                                          withServiceName:(NSString*) serviceName
                                                           withParameters:(NSMutableDictionary*) params
                                                             withFileData:(NSArray*) files
                                                              withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                              withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
    
//    NSString *serviceUrl = [httpBaseURL stringByAppendingPathComponent:serviceName];
    
     NSString *serviceUrl = [BASE_URL_SYNC stringByAppendingPathComponent:serviceName];
    
    if (headers == nil)
    {
        NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"multipart/form-data",@"Content-Type",nil];
        [self setHeaders:headers];
    }
    else
    {
        [headers setObject:@"multipart/form-data" forKey:@"Content-Type"];
        [self setHeaders:headers];
    }
    
    NSURLSessionDataTask *dataTask = [httpSessionManager POST:serviceUrl
                                                   parameters:params
                                    constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                        
                                        for (NSData *fileData in files)
                                        {
                                            [formData appendPartWithFileData:fileData name:@"contacts" fileName:@"MyContacts.zip" mimeType:@"application/octet-stream"];
                                        }
                                    }
                                                     progress:nil
                                                      success:^(NSURLSessionDataTask *task, id responseObject) {
                                                          
                                                          [self removeTask:task];
                                                          
                                                          if (success != nil)
                                                              success(task,responseObject);
                                                      }
                                                      failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                          
                                                          [self removeTask:task];
                                                          
                                                          if (failure != nil)
                                                              failure(task,error);
                                                      }];
    
    if (dataTask != nil) {
        
        [self addTask:dataTask];
        
        return dataTask;
    }else {
        return nil;
    }
}

- (NSURLSessionDataTask*) startRequestWithContactSyncHttpMethod:(kHttpMethodType) httpMethodType
                                     withHttpHeaders:(NSMutableDictionary*) headers
                                     withServiceName:(NSString*) serviceName
                                      withParameters:(NSMutableDictionary*) params
                                         withSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSAssert(serviceName, ([NSString stringWithFormat:@"\n<------------------->\n%@\n%sn<------------------->",@"serviceName can't be nil",__PRETTY_FUNCTION__]));
    
//    NSString *serviceUrl = [httpBaseURL stringByAppendingFormat:@"%@",serviceName];
    NSString *serviceUrl = serviceName;

    
    NSLog(@"URL :%@",serviceUrl);
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *tzName = [timeZone name];
    NSLog(@"Time zone : %@",tzName);
    
    if (headers == nil)
    {
        NSDictionary *headers = [[NSDictionary alloc] initWithObjectsAndKeys:@"application/json",@"Accept",@"application/json",@"Content-Type",tzName,@"timezone",nil];
        
        [self setHeaders:headers];
    }
    else
    {
        [headers setObject:@"application/json" forKey:@"Accept"];
        [headers setObject:@"application/json" forKey:@"Content-Type"];
        [headers setObject:tzName forKey:@"timezone"];
        
        [self setHeaders:headers];
    }
    
    
    NSLog(@"headers = %@",headers);
    
    if (params != nil)
        [self addQueryStringWithParams:params];
    
    switch (httpMethodType)
    {
        case kHttpMethodTypeGet:
        {
            NSURLSessionDataTask *dataTask =  [httpSessionManager GET:serviceUrl
                                                           parameters:params
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                  
                                                                  if (success != nil)
                                                                      success(task,responseObject);
                                                              }
                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  
                                                                  if (failure != nil)
                                                                      failure(task,error);
                                                              }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
        case kHttpMethodTypePost:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager POST:serviceUrl
                                                           parameters:params
                                                             progress:nil
                                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                  
                                                                  if (success != nil)
                                                                      success(task,responseObject);
                                                              }
                                                              failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                  
                                                                  if (failure != nil)
                                                                      failure(task,error);
                                                              }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
        case kHttpMethodTypeDelete:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager DELETE:serviceUrl
                                                             parameters:params
                                                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                    
                                                                    if (success != nil)
                                                                        success(task,responseObject);
                                                                }
                                                                failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                    
                                                                    if (failure != nil)
                                                                        failure(task,error);
                                                                }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
        case kHttpMethodTypePut:
        {
            NSURLSessionDataTask *dataTask = [httpSessionManager PUT:serviceUrl
                                                          parameters:params
                                                             success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                 
                                                                 if (success != nil)
                                                                     success(task,responseObject);
                                                             }
                                                             failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                                 
                                                                 if (failure != nil)
                                                                     failure(task,error);
                                                             }];
            
            if (dataTask != nil) {
                
                [self addTask:dataTask];
                
                return dataTask;
            }else {
                return nil;
            }
        }
            break;
            
        default:
            break;
    }
}


- (void) cancelAllTasks {
    
    for (NSURLSessionDataTask *task in arrayRunningTasks) {
        [task cancel];
    }
}
@end
