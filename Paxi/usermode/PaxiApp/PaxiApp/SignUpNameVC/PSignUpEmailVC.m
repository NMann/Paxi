//
//  PSignUpEmailVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignUpEmailVC.h"
#import "PCardInfoVC.h"
@interface PSignUpEmailVC ()
//843cc5f62b974f8a8b7620557200d11e
@end

@implementation PSignUpEmailVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view endEditing:YES];
    //    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PAppManager sharedData] m_AddPadding:self.emailTextField];
    [[PAppManager sharedData] m_AddPadding:self.passwordTextField];
    /* ChangePlaceHolder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.emailTextField];
    /* ChangePlaceHolder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.passwordTextField];
    /*Add Swipe Gesture*/
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_SwipeGesture:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
    
     userid=[[NSUserDefaults standardUserDefaults]valueForKey:@"userid"];
}

#pragma mark- Swipe Gesture Implementation-
-(void)m_SwipeGesture:(UISwipeGestureRecognizer*)sender
{
    if ([sender state]==UIGestureRecognizerStateRecognized)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Tap Gesture Implementation-
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}
#pragma mark - Method Implementation-
- (IBAction)m_NextButtonPressed:(id)sender
{
    if ([self.emailTextField.text length]>0 && [self.passwordTextField.text length]>0 && ![self.emailTextField.text isEqualToString:@"Email"]&&![self.passwordTextField.text isEqualToString:@"Password"] )
    {
        if ([self NSStringIsValidEmail:self.emailTextField.text])
        {
            [[NSUserDefaults standardUserDefaults] setValue:self.emailTextField.text forKey:@"emailId"];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
    
           [SVProgressHUD showWithStatus:@"Please Wait...."];
            
            NSString *string = [NSString stringWithFormat:@"&email=%@&userid=%@",self.emailTextField.text,userid];
            [[PApiCall sharedInstance] m_GetApiResponse:@"emailVerfication" parameters:string onCompletion:^(NSDictionary *json) {
                  NSLog(@"string is%@",string);
                NSDictionary *dic = (NSDictionary *)json;
                NSLog(@"%@", dic);
                if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
                {
                    [SVProgressHUD showSuccessWithStatus:@"Done"];
                    if([[[dic valueForKey:@"data"] valueForKey:@"active"] isEqualToString:@"yes"]){
                        NSString *nibName=@"PCardInfoVC";
                            if (IS_IPHONE5)
                         nibName=@"PCardInfoVC_5";
                         PCardInfoVC *cardInfoVC=[[PCardInfoVC alloc]initWithNibName:nibName bundle:nil];
                         [self.navigationController pushViewController:cardInfoVC animated:YES];
                    }else{
                        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Verify Email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                        [alert show];
                    }
                }
                else if ([[dic valueForKey:@"return"] integerValue]==0)
                {
                    [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"data"]];
                    
                }
                else
                {
                    [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
                }
            }];
        }
       else
       {
           UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter Valid Email Id." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
           [alert show];
       }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter The Required Information." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
   }
#pragma mark - Method To Add Padding-
-(void)m_AddPadding:(UITextField*)Sender
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    Sender.leftView = paddingView;
    Sender.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"Email"] ||[textField.text isEqualToString:@"Password"])
    {
        textField.text=@"";
    }
    [self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"Email"] ||[textField.text isEqualToString:@"Password"])
    {
        textField.text=@"";
    }
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 100)];
        [nextResponder becomeFirstResponder];
    }
    else
    {
        // Not found, so remove keyboard.
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        [textField resignFirstResponder];
    }
    return YES;
}
#pragma mark-
#pragma mark -Validate Email-
-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
