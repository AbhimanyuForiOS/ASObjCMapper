//
//  Model.h
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestDict.h"
#import "Friend.h"
#import "Enimy.h"
@interface Model : NSObject

@property(retain,nonatomic)NSString *body;
@property(retain,nonatomic)TestDict *innerInfo;
@property(retain,nonatomic)NSMutableArray *friends;

@end
