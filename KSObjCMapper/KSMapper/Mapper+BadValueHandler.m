//
//  Mapper+BadValueHandler.m
//  Mapper
//
//  Created by Abhimanyu  on 02/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper+BadValueHandler.h"

@implementation Mapper (BadValueHandler)
+(BOOL)isBadValue:(id)value{

    if (value == [NSNull null] || value == nil || value == Nil ||  value == NULL) {
        return true;
    }
    return false;
}

@end
