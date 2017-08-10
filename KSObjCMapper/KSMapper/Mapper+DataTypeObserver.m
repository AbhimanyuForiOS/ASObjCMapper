//
//  Mapper+DataTypeObserver.m
//  Mapper
//
//  Created by Abhimanyu  on 02/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper+DataTypeObserver.h"
#import "Mapper+Helper.h"
#import "Mapper+BadValueHandler.h"
#import "objc/runtime.h"

@implementation Mapper (DataTypeObserver)



+(NSString *)collectionClassWithKey:(NSString *)key inModel:(id)model{
    
   NSString * className = @"";
   NSMutableArray * arr =  [model valueForKey:key];
    for (id obj in arr) {
        className = NSStringFromClass([obj class]);
    }
    [arr removeAllObjects];

    return className;
}






+(id)returnValue:(id)value key:(NSString *)key inModel:(id)model {
    
    NSString *className = [self getInnerModel:key inModel:model];

    
    
    //NESTED NSMutableDictionary
    if ([value isKindOfClass:[NSMutableDictionary class]]) {
        
                    id model =  [[NSClassFromString(className) alloc] init];
        
                        for (NSString * key in value) {
                            id val = [value objectForKey:key];
                        
                            if ([self isKeyAvailableIn: model withKey:key]){
                                if(![self isBadValue:val])
                                    [model setValue:[self returnValue:val key:key inModel:model]  forKey:key];
                            }

                        }
                return model;
    }
    
    
    
   
    //NESTED NSDictionary
    if ([value isKindOfClass:[NSDictionary class]]) {
        
                       id model =  [[NSClassFromString(className) alloc] init];
                
                        for (NSString * key in value) {
                            id val = [value objectForKey:key];
                            
                            if ([self isKeyAvailableIn: model withKey:key]){
                                if(![self isBadValue:val])
                                     [model setValue:[self returnValue:val key:key inModel:model]  forKey:key];
                            }
                            
                        }
                return model;
    }
    
    
    
    
    
   //NESTED NSMutableArray
    if ([value isKindOfClass:[NSMutableArray class]]) {
      
        NSMutableArray * arr = (NSMutableArray *)value;
        
        NSMutableArray * items = [[NSMutableArray alloc]init];
        NSString * strClassName = [self collectionClassWithKey:key inModel:model];
        id m =  [[NSClassFromString(strClassName) alloc] init];
                        for (int i = 0; i<arr.count; i++) {
                            
                            NSMutableDictionary * dict = [arr  objectAtIndex:i];
                      
                            
                            for (NSString * key in dict) {
                                
                                id val = [dict objectForKey:key];

                                if ([self isKeyAvailableIn: m withKey:key]){
                                    if(![self isBadValue:val])
                                        [m setValue:[self returnValue:val key:key inModel:m]  forKey:key];
                                }
                                
                            }
                         [items addObject:m];
                        }
        return items;
    }
    
    
    
    
    //NESTED NSArray
    if ([value isKindOfClass:[NSArray class]]) {
        
        NSMutableArray * arr = (NSMutableArray *)value;
        
        NSMutableArray * items = [[NSMutableArray alloc]init];
      
        NSString * strClassName = [self collectionClassWithKey:key inModel:model];
        id m =  [[NSClassFromString(strClassName) alloc] init];
                        for (int i = 0; i<arr.count; i++) {
                            
                            NSMutableDictionary * dict = [arr  objectAtIndex:i];
                            
                        
                            
                            for (NSString * key in dict) {
                                
                                id val = [dict objectForKey:key];
                                
                                if ([self isKeyAvailableIn: model withKey:key]){
                                    if(![self isBadValue:val])
                                        [m setValue:[self returnValue:val key:key inModel:m]  forKey:key];
                                }
                            }
                             [items addObject:m];
                        }
        return items;
    }
    
    
    return value;
}

@end
