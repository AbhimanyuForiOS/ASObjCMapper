//
//  Mapper+Helper.m
//  Mapper
//
//  Created by Abhimanyu  on 01/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper+Helper.h"

@implementation Mapper (Helper)



#pragma mark:- Property "Key" Finder
+(BOOL)isKeyAvailableIn:(id)model withKey:(NSString *)keyJson{
    
    BOOL isAvailable = false;
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    
    for(i = 0; i < outCount; i++) {
    
        objc_property_t property = properties[i];
       
        const char *propName = property_getName(property);
  
  
        if(propName) {
           
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            if ([propertyName isEqualToString:keyJson])
                isAvailable = true;
            
        }
    }
    free(properties);
    return isAvailable;
}



#pragma mark:- Property "Type of Model" Finder

static const char *getPropertyType(objc_property_t property) {

    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    
    strcpy(buffer, attributes);
    
    char *state = buffer, *attribute;
    
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (strlen(attribute) <= 4) {
                break;
            }
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}




+(NSString *)getInnerModel:(NSString *)key inModel:(id)model{
    
  
    NSString *modelName = @"";
    unsigned int outCount, i;
   
    objc_property_t *properties = class_copyPropertyList([model class], &outCount);
    
    for(i = 0; i < outCount; i++) {
    
        objc_property_t property = properties[i];
        
        const char *propName = property_getName(property);
        
        if(propName) {
        
            NSString *propertyName = [NSString stringWithUTF8String:propName];
           
            if ([propertyName isEqualToString:key]){
               
                const char *propType = getPropertyType(property);
                NSString *propertyType = [NSString stringWithCString:propType
                                                            encoding:[NSString defaultCStringEncoding]];
                modelName = propertyType;
            }
           
        }
    }
    free(properties);
    
    return modelName;
}




@end
