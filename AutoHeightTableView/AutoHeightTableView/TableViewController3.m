//
//  TableViewController3.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/27.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewController3.h"
#import "TableViewCell1.h"
#import "UITableView+FDTemplateLayoutCell.h"

@interface TableViewController3 ()
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) UITableViewCell *cell;
@end

@implementation TableViewController3

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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:tableViewCell1 cacheByIndexPath:indexPath configuration:^(TableViewCell1 *cell) {
        [cell initCellView:[_data objectAtIndex:indexPath.row]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell1 *cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewCell1];
    [cell initCellView:[_data objectAtIndex:indexPath.row]];
    return cell;
}

@end
