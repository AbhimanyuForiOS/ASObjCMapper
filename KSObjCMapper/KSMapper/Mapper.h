//
//  Mapper.h
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mapper : NSObject

/*
 - This Fuction "fillModel: withDict:" will transfer your JSON Dictionary  to your NSObject class
*/

+(id)fillModel:(NSString *)className withDict:(NSMutableDictionary *)dict;

/*
 - This Fuction "fillModels: withArray:" will transfer your JSON Array to your NSObject  Model  NSMutableArray class
*/

+(NSMutableArray * )fillModels:(NSString *)className withArray:(id)response;


@end
