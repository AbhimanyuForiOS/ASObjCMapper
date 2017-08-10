//
//  InterestService.h
//  Reveel
//
//  Created by Ruchika on 16/06/17.
//  Copyright © 2017 Reveel ™ and Leever, Inc. (Delaware, USA). All rights reserved.
//

#import "HTTPService.h"

@interface InterestService : HTTPService

- (void)getInterestAPIWithSuccess:(void (^)(NSURLSessionDataTask *task, id responseObject))success
           withFailure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



@end
