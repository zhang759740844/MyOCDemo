//
//  TableViewCell1.m
//  AutoHeightTableViewDemo
//
//  Created by Zachary on 16/8/24.
//  Copyright © 2016年 Zachary. All rights reserved.
//

#import "TableViewCell1.h"

@implementation TableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellView:(NSString *)label{
    _label.text = label;
    _image.image =[UIImage imageNamed:@"Image"];
//    self.selectionStyle= UITableViewCellSelectionStyleNone;
}
- (void)buttonPressed:(id)sender withEvent:(UIEvent *)event{
    NSLog(@"%@",event);
    [self.delegate buttonPressed:self event:event];
    NSLog(@"--");
}

@end
