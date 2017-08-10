//
//  InterestService.m
//  Reveel
//
//  Created by Ruchika on 16/06/17.
//  Copyright © 2017 Reveel ™ and Leever, Inc. (Delaware, USA). All rights reserved.
//

#import "InterestService.h"

@implementation InterestService


- (void)getInterestAPIWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                         withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure {
    

    [self startRequestWithHttpMethod:kHttpMethodTypeGet withHttpHeaders:nil withServiceName:@"" withParameters:nil withSuccess:success withFailure:failure];
}



@end
