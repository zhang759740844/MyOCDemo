//
//  TableViewController2.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/25.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewController2.h"
#import "TableViewCell2.h"
@interface TableViewController2 ()
@property (nonatomic, strong) NSMutableArray *data;
@property (nonatomic, strong) TableViewCell2 *cell;
@end

@implementation TableViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [NSMutableArray arrayWithArray:@[@"1\n2\n3\n4\n5\n6\n7\n8",@"1\n2\n3\n4\n5\n6\n7",@"1\n2\n3\n4\n5\n6",@"1\n2\n3\n4\n5",@"1\n2\n3\n4",@"1\n2\n3",@"1\n2",@"1"]];
    [self.tableView registerNib:[UINib nibWithNibName:@"TableViewCell2" bundle:nil] forCellReuseIdentifier:tableViewCell2Identifier];
    _cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewCell2Identifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _cell.textView.text = [_data objectAtIndex:indexPath.row];
    CGSize textHeight = [_cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGSize textViewSize = [_cell.textView sizeThatFits:CGSizeMake(_cell.textView.frame.size.width, FLT_MAX)];
    CGFloat h  = textHeight.height + textViewSize.height;
    CGFloat height = h+1>90?h+1:90;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewCell2 *cell = [self.tableView dequeueReusableCellWithIdentifier:tableViewCell2Identifier];
    [cell initCellWithString:[_data objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

@end
