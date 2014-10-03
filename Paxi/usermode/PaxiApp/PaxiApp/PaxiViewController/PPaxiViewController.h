//
//  PPaxiViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPaxiViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;

- (IBAction)m_MyProfileButtonPressed:(id)sender;
- (IBAction)m_MyPaymentsButtonPressed:(id)sender;
- (IBAction)m_LogOffButtonPressed:(id)sender;
- (IBAction)m_FavoriteAddressButtonPressed:(id)sender;
- (IBAction)m_FavoriteDriverButtonPressed:(id)sender;
- (IBAction)m_HelpButtonPressed:(id)sender;
- (IBAction)m_pickUpButtonPressed:(id)sender;
- (IBAction)m_TaxiButtonPressed:(id)sender;
- (IBAction)m_ActivitiesButtonPressed:(id)sender;
- (IBAction)m_MyPaxiButtonPressed:(id)sender;

@end
