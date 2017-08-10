//
//  Mapper+Helper.h
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper.h"
#import "objc/runtime.h"
@interface Mapper (Helper)

/*

 - This Fuction "isKeyAvailableIn:(id)model withKey:(NSString *)keyJson" will check your model property existance....
 
*/

+(BOOL)isKeyAvailableIn:(id)model withKey:(NSString *)keyJson;

/*
 
 - This Fuction "getInnerModel:(NSString *)key inModel:(id)model" for nested models dynamacly (inner arrays ,inner dictionaries)....
 
*/

+(NSString *)getInnerModel:(NSString *)key inModel:(id)model;

@end
