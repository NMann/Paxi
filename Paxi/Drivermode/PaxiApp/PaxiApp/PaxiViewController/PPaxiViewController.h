//
//  PPaxiViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPaxiViewController : UIViewController{
    NSString *locationName;
}
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
- (IBAction)m_MyProfileButtonPressed:(id)sender;
- (IBAction)m_MyAccountButtonPressed:(id)sender;
- (IBAction)m_LogOffButtonPressed:(id)sender;

@end
