//
//  PTaxiRequestCell.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTaxiRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAdressLabel;
@property (weak, nonatomic) IBOutlet UIButton *sourceButton;
@property (weak, nonatomic) IBOutlet UIButton *destinationButton;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;

@end
