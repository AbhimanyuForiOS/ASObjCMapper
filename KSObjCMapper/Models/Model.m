//
//  Model.m
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Model.h"

@implementation Model

@synthesize body;
@synthesize innerInfo;
@synthesize friends;
- (instancetype)init
{
    self = [super init];
    if (self) {
            self.friends = [[NSMutableArray alloc]initWithObjects:[[Friend alloc]init], nil];
            
    }
    return self;
}




@end
