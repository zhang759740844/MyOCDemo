//
//  TableViewController1.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewController1.h"
#import "TableViewCell1.h"
@interface TableViewController1 ()
@property (nonatomic, strong) NSMutableArray *data;
//  heightForRowAtIndexPath 需要用到
@property (nonatomic, strong) TableViewCell1 *cell;
@end

@implementation TableViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray arrayWithArray:@[@"1\n2\n3\n4\n5\n6\n7\n8",@"1\n2\n3\n4\n5\n6\n7",@"1\n2\n3\n4\n5\n6",@"1\n2\n3\n4\n5",@"1\n2\n3\n4",@"1\n2\n3",@"1\n2",@"1"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell1" bundle:nil] forCellReuseIdentifier:tableViewCell1];
    _cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewCell1];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell1 *cell = [tableView dequeueReusableCellWithIdentifier:tableViewCell1];
    [cell initCellView:[_data objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell.label.text = [_data objectAtIndex:indexPath.row];
    CGSize textHeight = [_cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = textHeight.height+1>90?textHeight.height+1:90;
    return height;
}

// 会先调用N次获取tableview的大致高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}


@end
