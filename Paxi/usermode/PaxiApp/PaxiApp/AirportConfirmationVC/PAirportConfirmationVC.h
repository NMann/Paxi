//
//  PAirportConfirmatioVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAirportConfirmationVC : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signatureButton;
@property(nonatomic,strong)NSString *strSourceAddress;
@property(nonatomic,strong)NSString *strDestinationAddress;
@property(nonatomic,strong)NSString *strBasicFee;
@property(nonatomic,strong)NSString *strAirportCharges;
@property(nonatomic,strong)NSString *strTotalFee;
@property(nonatomic,strong)NSString *strId;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *basicFeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *airportServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalFeeLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *meetingTextField;

- (IBAction)m_SendRequestButtonPressed:(id)sender;
- (IBAction)m_SignatureButtonPressed:(id)sender;
- (IBAction)m_EditButtonPressed:(id)sender;
- (IBAction)m_DoneButtonPressed:(id)sender;

@end
