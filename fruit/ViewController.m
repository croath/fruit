//
//  ViewController.m
//  fruit
//
//  Created by croath on 12/15/14.
//  Copyright (c) 2014 Croath. All rights reserved.
//

#import "ViewController.h"
#import "CRFruitView.h"
@interface ViewController (){
    CRFruitView *_v;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _v = [[CRFruitView alloc] initWithFrame:CGRectMake(0.0, 100.0, 300.0, 100.0)];
    [self.view addSubview:_v];
    
    
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont systemFontOfSize:25.0];
    
    NSDictionary *dict = @{NSFontAttributeName:font,
                           NSForegroundColorAttributeName:[UIColor colorWithWhite:150.0/255.f alpha:1.0],
                           NSBackgroundColorAttributeName:[UIColor clearColor],
                           NSParagraphStyleAttributeName:style};
    [_v setTextAttr:dict];
    [_v setCharSize:CGSizeMake(20.0, 100.0)];
    [_v setVerticalMargin:0.0];
    [_v setHorizontalMargin:20.0];
    [_v setIncrementRoll:NO];
    [_v setDownRoll:NO];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(50.0, 300.0, 100.0, 50.0)];
    [button setTitle:@"Random" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(random) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)random{
    [_v setInteger:arc4random()%1000];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
