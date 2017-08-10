//
//  TestDict.m
//  Mapper
//
//  Created by Abhimanyu  on 02/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "TestDict.h"
#import "Enimy.h"

@implementation TestDict
@synthesize name,enimy,dict;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enimy = [[NSMutableArray alloc]initWithObjects:[[Enimy alloc]init], nil];
        
    }
    return self;
}
@end
