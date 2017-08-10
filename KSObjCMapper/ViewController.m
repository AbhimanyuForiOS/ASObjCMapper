//
//  ViewController.m
//  KSObjCMapper
//
//  Created by Abhimanyu  on 03/08/17.
//  Copyright © 2017 Konstant. All rights reserved.
//

#import "ViewController.h"
#import "Mapper.h"
#import "Model.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    
        NSString    *filePath   = [[NSBundle mainBundle] pathForResource:@"MyJson" ofType:@"json"];
        NSData      *data       = [NSData dataWithContentsOfFile:filePath];
    
        id response =    [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
        NSLog(@"response %@",response);
    
        NSMutableArray * arr = [Mapper fillModels:@"Model" withArray:response];
    
        for (int i = 0; i<arr.count; i++) {
    
            Model * m = (Model *)[arr objectAtIndex:i];
    
            
            
            //information
            NSLog(@"m.name %@",m.body);
            NSLog(@"m.innerInfo.name %@",m.innerInfo.name);
            NSLog(@"m dict name  %@",m.innerInfo.dict.name);
    
            
            //counts
            NSLog(@"friends %lu",(unsigned long)m.friends.count);
            NSLog(@"friends %lu",(unsigned long)m.innerInfo.enimy.count);
    
    
            
            //your friends
            for (int j = 0; j<m.friends.count; j++) {
    
                TestDict * friend = (TestDict *)[m.friends objectAtIndex:j];
                NSLog(@"friend name %@",friend.name);
            }
    
            
            //your enimies
            for (int j = 0; j<m.innerInfo.enimy.count; j++) {
                Enimy * enimy = (Enimy *)[m.innerInfo.enimy objectAtIndex:j];
                NSLog(@"enimy name %@",enimy.name);
            }
        }
}

-(void)callByService{
    
//            InterestService * interest = [[InterestService alloc]init];
//    
//            [interest getInterestAPIWithSuccess:^(NSURLSessionDataTask *task, id responseObject) {
//    
//                NSLog(@"responseObject %@",responseObject);
//                Model * obj = (Model *)[Mapper fillModel:@"Model" withDict:responseObject];
//                NSLog(@"obj %@",obj.body);
//    
//            } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
//    
//            }];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
