//
//  ViewController.m
//  SharderOPENGL
//
//  Created by ChenYuanfu on 2018/11/18.
//  Copyright © 2018年 Zerozero. All rights reserved.
//

#import "ViewController.h"
#import "SharderManger.h"
#import "DisplayView.h"

@interface ViewController ()
@property (nonatomic, strong) DisplayView *displayview;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    DisplayView *displayView = [[DisplayView alloc] initWithFrame:CGRectMake(0,0,375,667)];
    self.displayview = displayView;
    [self.view addSubview:displayView];
    [self.displayview praperDisplay];
    [self.displayview display];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"This is dispaly");
        [self.displayview display];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
