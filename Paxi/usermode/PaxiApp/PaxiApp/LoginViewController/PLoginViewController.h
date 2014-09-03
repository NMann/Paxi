//
//  PLoginViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)m_LoginButtonPressed:(id)sender;


@end
