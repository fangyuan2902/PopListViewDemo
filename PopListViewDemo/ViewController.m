//
//  ViewController.m
//  PopListView
//
//  Created by *** on 2017/7/31.
//  Copyright © 2017年 yuanfang. All rights reserved.
//

#import "ViewController.h"
#import "PopListView.h"

@interface ViewController () <PopListViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.view addSubview:button];
    [button addTarget:self action:@selector(touches) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touches {
    PopListView *pop = [[PopListView alloc] initWithTitle:@"请选择" listArray:@[@"0",@"1"] selectStyle:PopViewListSelectStyleLeft];
    [pop setButtonStyle:PopViewListButtonStyleSureAndCancel];
    pop.titleString = @"请选择";
    pop.delegate = self;
    [pop showInView:self.view];
    
}

- (void)sureButtonActionIndex:(NSInteger)index {
    NSLog(@"select===:%ld", (long)index);
}

-(void)cancelButtonActionIndex:(NSInteger)index {
    NSLog(@"cancel===:");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
