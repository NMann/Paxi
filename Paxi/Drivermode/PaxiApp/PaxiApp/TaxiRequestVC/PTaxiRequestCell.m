//
//  PTaxiRequestCell.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PTaxiRequestCell.h"

@implementation PTaxiRequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)layoutSubviews
{
    self.imageBorderButton.layer.cornerRadius=25.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=1.0;
    self.profileImageView.layer.cornerRadius=25.0;
    self.sourceButton.layer.cornerRadius=13.0;
    self.sourceButton.layer.borderWidth=1.0;
    self.sourceButton.layer.borderColor=[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0].CGColor;
    self.sourceButton.layer.masksToBounds=YES;
    self.destinationButton.layer.cornerRadius=13.0;
    self.destinationButton.layer.borderWidth=1.0;
    self.destinationButton.layer.borderColor=[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0].CGColor;
    self.acceptButton.layer.cornerRadius=10.0;
    self.acceptButton.layer.borderWidth=1.0;
    self.acceptButton.layer.borderColor=[UIColor whiteColor].CGColor;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
