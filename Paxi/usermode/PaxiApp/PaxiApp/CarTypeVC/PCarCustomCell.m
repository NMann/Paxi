//
//  PCarCustomCell.m
//  PaxiApp
//
//  Created by Ankush Sharma on 02/09/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PCarCustomCell.h"

@implementation PCarCustomCell
@synthesize CarInfolabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.CarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(24,0,72,32)];
        self.CarImageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview: self.CarImageView];
        
        
        CarInfolabel = [[UILabel alloc] init];
        [CarInfolabel setFrame:CGRectMake(0,40,120,70)];
        CarInfolabel.textAlignment=NSTextAlignmentCenter;
        CarInfolabel.numberOfLines=3;
        CarInfolabel.font=[UIFont fontWithName:@"Helvetica Neue " size:14.0];
        //CarInfolabel.backgroundColor=[UIColor redColor];
        CarInfolabel.textColor=[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0];
        CarInfolabel.textColor=[UIColor whiteColor];
        CarInfolabel.userInteractionEnabled=YES;
        [self addSubview:CarInfolabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
