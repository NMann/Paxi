//
//  PPassengerInfoViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPassengerInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;
@property(nonatomic,retain)PAirportRequest *requestDetail;

@property (weak, nonatomic) IBOutlet UILabel *flightNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNoLabel;
- (IBAction)m_NextButtonPressed:(id)sender;
@end
