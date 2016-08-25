//
//  TableViewCell1.h
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *tableViewCell1 = @"tableViewCell1";
@interface TableViewCell1 : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *label;

- (void)initCellView:(NSString *)label;
@end
