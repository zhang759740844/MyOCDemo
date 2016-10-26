//
//  zacharyViewController.m
//  StaticWithCocoapods
//
//  Created by Zachary on 10/25/2016.
//  Copyright (c) 2016 Zachary. All rights reserved.
//

#import "zacharyViewController.h"
#import "StaticWithCocoapods/SVProgress.h"
#import "StaticWithCocoapods/PrintString.h"
@interface zacharyViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@end

@implementation zacharyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [PrintString printString];
    UIImage *image = [PrintString getImage];
    [_imageView setImage:image];
    [SVProgress getBlock]();
}


@end
