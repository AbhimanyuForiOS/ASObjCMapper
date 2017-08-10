
//
//  Mapper.m
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper.h"
#import "Mapper+Helper.h"
#import "Mapper+DataTypeObserver.h"
#import <UIKit/UIKit.h>
#import "Mapper+BadValueHandler.h"


@implementation Mapper

/*

 - This Fuction "fillModel: withDict:" will transfer your JSON Dictionary  to your NSObject class

*/


#pragma mark:- NSMutableDictionary Dynamic enumuration for models

+(id)fillModel:(NSString *)className withDict:(NSMutableDictionary *)dict{
    
        id model = [[NSClassFromString(className) alloc] init];
    
        for (NSString * key in dict) {

            id val = [dict objectForKey:key];
            
            if ([self isKeyAvailableIn: model withKey:key]){
                        if(![self isBadValue:val])
                            [model setValue:[self returnValue:val key:key inModel:model]   forKey:key];
            }
        }
    return model;
}

/*

 - This Fuction "fillModels: withArray:" will transfer your JSON Array to your NSObject  Model  NSMutableArray class
 
*/
#pragma mark:- NSMutableArray Dynamic enumuration for models

+(NSMutableArray * )fillModels:(NSString *)className withArray:(id)response{
    
    NSMutableArray * arr = (NSMutableArray *)response;
    
    NSMutableArray * items = [[NSMutableArray alloc]init];
    
    for (int i = 0; i<arr.count; i++) {
        
            NSMutableDictionary * dict = [arr  objectAtIndex:i];
    
            id model = [[NSClassFromString(className) alloc] init];
        
            for (NSString * key in dict) {
                
                id val = [dict objectForKey:key];
                        if ([self isKeyAvailableIn: model withKey:key]){
                                if(![self isBadValue:val])
                                            [model setValue:[self returnValue:val key:key inModel:model]  forKey:key];
                        }
                
    
                
                }
        [items addObject:model];
    }
    return items;
}


@end
