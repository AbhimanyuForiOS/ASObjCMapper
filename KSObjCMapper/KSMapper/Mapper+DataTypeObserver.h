//
//  Mapper+DataTypeObserver.h
//  Mapper
//
//  Created by Abhimanyu  on 02/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "Mapper.h"

@interface Mapper (DataTypeObserver)


/*
    - First This Fuction "+(id)returnValue:(id)value key:(NSString *)key inModel:(id)model" will observer data type which is comming from server......
 
 
    - Secondly This Fuction "returnValue: key:" will fill "Model's Property" which you associated with Server value......

 */



+(id)returnValue:(id)value key:(NSString *)key inModel:(id)model ;

@end
