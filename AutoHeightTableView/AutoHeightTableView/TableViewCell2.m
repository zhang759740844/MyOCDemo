//
//  TableViewCell2.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/25.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewCell2.h"

@implementation TableViewCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithString:(NSString *)text{
    self.textView.text = text;
    self.image.image = [UIImage imageNamed:@"Image"];
}

@end
