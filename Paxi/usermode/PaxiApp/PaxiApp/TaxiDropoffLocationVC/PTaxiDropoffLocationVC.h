//
//  PTaxiDropoffLocationVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 23/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFavoriteAddressVC.h"

@interface PTaxiDropoffLocationVC : UIViewController<UITextFieldDelegate ,PFavoriteAddressVCDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;
@property(nonatomic,strong)NSString *strSourceAddress;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (IBAction)m_SkipButtonPressed:(id)sender;
- (IBAction)m_SendRequestButtonPressed:(id)sender;
- (IBAction)m_FavoriteButtonPressed:(id)sender;

@end
