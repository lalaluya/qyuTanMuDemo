//
//  ViewController.m
//  AnimationForMove
//
//  Created by 余强 on 16/2/29.
//  Copyright © 2016年 bdcluster(上海大数聚科技有限公司). All rights reserved.
//

#import "ViewController.h"

#import "MoveView.h"
#import "MoveView2.h"
#import "MoveView3.h"


@interface ViewController ()

@property(nonatomic,strong) MoveView3 *moveView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
  //dataSource
    NSString *danmakufile = [[NSBundle mainBundle] pathForResource:@"file" ofType:nil];
    NSArray *fileArray = [NSArray arrayWithContentsOfFile:danmakufile];
    
    NSMutableArray *dataArray2 = [@[] mutableCopy];
    for (NSDictionary *dic in fileArray) {
        [dataArray2 addObject:dic[@"m"]];
    }
    
    
    

    
    
    __weak typeof(self) weakSelf = self;
    self.moveView = [[MoveView3 alloc]initWithFrame:CGRectMake(0, 80, [UIScreen mainScreen].bounds.size.width, 240) dataArray:dataArray2 tapBlock:^(NSInteger index) {
        NSLog(@"点击了:%@",dataArray2[index]);
        [weakSelf.moveView pause];
        
        [weakSelf performSegueWithIdentifier:@"push" sender:nil];
    }];
    [self.view addSubview: self.moveView];
    
    self.moveView.layer.contents = (id)[UIImage imageNamed:@"house.jpg"].CGImage;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    [self.moveView resume];
    
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
     [self.moveView pause];

}




@end
