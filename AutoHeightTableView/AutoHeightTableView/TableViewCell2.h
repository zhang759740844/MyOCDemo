//
//  TableViewCell2.h
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/25.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *tableViewCell2Identifier = @"TableViewCell2Identifier";

@interface TableViewCell2 : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UITextView *textView;

- (void)initCellWithString:(NSString *)text;
@end
