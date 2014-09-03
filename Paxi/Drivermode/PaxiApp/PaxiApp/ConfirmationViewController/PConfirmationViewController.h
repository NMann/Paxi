//
//  PConfirmationViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PConfirmationViewController : UIViewController<UIPrintInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,strong)PAirportRequest *requestDetail;

@property (weak, nonatomic) IBOutlet UILabel *basicFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *airPortServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *signatureImageView;
- (IBAction)m_printButtonPressed:(id)sender;
- (IBAction)m_ConfirmButtonPressed:(id)sender;
@end
