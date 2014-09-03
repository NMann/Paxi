//
//  PSignUpEmailVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSignUpEmailVC : UIViewController{
    NSString *userid;
}
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)m_NextButtonPressed:(id)sender;

@end
