//
//  TableViewCell1.h
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TableViewCell1;
@protocol MyDelegate <NSObject>

- (void)buttonPressed:(TableViewCell1 *)cell event:(UIEvent*) event;
@end

static NSString *tableViewCell1 = @"tableViewCell1";
@interface TableViewCell1 : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UIButton *button;

- (IBAction)buttonPressed :(id)sender withEvent:(UIEvent*)event;
- (void)initCellView:(NSString *)label;

@property (nonatomic,weak) id<MyDelegate> delegate;
@end
