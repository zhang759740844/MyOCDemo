//
//  ViewController.m
//  AutoHeightTableView
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController1.h"
#import "TableViewController2.h"
#import "TableViewController3.h"
@interface ViewController ()
@property (nonatomic,weak) IBOutlet UIButton *first;

@property (nonatomic,weak) IBOutlet UIButton *second;

@property (nonatomic,weak) IBOutlet UIButton *third;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)firstTableView:(id)sender{
    TableViewController1 *vc1 = [[TableViewController1 alloc]init];
    [self.navigationController pushViewController:vc1 animated:YES];
}

- (IBAction)secondTableView:(id)sender{
    TableViewController2 *vc2 = [[TableViewController2 alloc]init];
    [self.navigationController pushViewController:vc2 animated:YES];
}

- (IBAction)thirdTableView:(id)sender{
    TableViewController3 *vc3 = [[TableViewController3 alloc]init];
    [self.navigationController pushViewController:vc3 animated:YES];
}

@end
