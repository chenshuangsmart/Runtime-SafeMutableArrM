//
//  ViewController.m
//  0416_safeMutableArrM
//
//  Created by cs on 2018/4/16.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self syncMutableArray];
}

- (void)syncMutableArray {
    NSMutableArray *safeArr = [[NSMutableArray alloc] init];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for ( int i = 0; i < 1000; i ++) {
        dispatch_async(queue, ^{
            NSLog(@"添加第%d个",i);
            [safeArr addObject:[NSString stringWithFormat:@"%d",i]];
        });
        
        dispatch_async(queue, ^{
            NSLog(@"删除第%d个",i);
            [safeArr removeObjectAtIndex:i];
        });
        
        dispatch_async(queue, ^{
            NSLog(@"读取第%d个数据:%@",i,[safeArr objectAtIndex:i]);
        });
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
