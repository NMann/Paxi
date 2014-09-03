//
//  PSignUpVerificationVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSignUpVerificationVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)m_NextButtonPressed:(id)sender;

@end
