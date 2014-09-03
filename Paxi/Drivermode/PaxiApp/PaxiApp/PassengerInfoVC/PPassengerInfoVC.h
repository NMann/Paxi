//
//  PPassengerInfoVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "PTaxiRequest.h"
@interface PPassengerInfoVC : UIViewController<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;

@property (strong, nonatomic) IBOutlet UIButton *detailInfoButton;

@property(nonatomic,strong)PTaxiRequest *taxiRequestDetail;
- (IBAction)m_CallButtonPressed:(id)sender;

- (IBAction)m_TextButtonPressed:(id)sender;
- (IBAction)downButtonPressed:(id)sender;
- (IBAction)m_StartButtonPressed:(id)sender;
- (IBAction)m_DetailButtonPressed:(id)sender;

@end
