//
//  PSummaryVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PTaxiRequest.h"

@interface PSummaryVC : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *profileIMageView;
@property (weak, nonatomic) IBOutlet UIButton *imageBorderButton;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLAbel;
@property (weak, nonatomic) IBOutlet UILabel *nameLAbel;
@property (weak, nonatomic) IBOutlet UILabel *pickupLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationLocationLabel;
@property(nonatomic,strong)PTaxiRequest *taxiRequestDetail;
- (IBAction)finishButtonPressed:(id)sender;

@end
