//
//  PSignUpNameVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSignUpNameVC : UIViewController<UITextFieldDelegate ,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>{
    NSString *type;
}
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *m_flagButton;
@property (strong, nonatomic) IBOutlet UITableView *m_flagtableview;
@property (strong, nonatomic) IBOutlet UILabel *m_codeLabel;

- (IBAction)m_NextButtonPressed:(id)sender;
- (IBAction)m_flagbuttonPressed:(id)sender;

@end
