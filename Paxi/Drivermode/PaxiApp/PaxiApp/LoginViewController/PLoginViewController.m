//
//  PLoginViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PLoginViewController.h"
#import "PHomeViewController.h"
#import "PSignUpViewController.h"

@interface PLoginViewController ()

@end

@implementation PLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - LifeCycle Method-
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*Add Padding In Text Field*/
    [[PAppManager sharedData] m_AddPadding:self.userNameTextField];
    [[PAppManager sharedData] m_AddPadding:self.passwordTextField];
    /* ChangePlaceHolder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.userNameTextField];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.passwordTextField];
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    [self.scrollView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Login Button Pressed-
- (IBAction)m_LoginButtonPressed:(id)sender
{
    if (self.userNameTextField.text.length>0 &&self.passwordTextField.text.length>0)
    {
        // 1
        if ([self NSStringIsValidEmail:self.userNameTextField.text])
        {
            [SVProgressHUD showWithStatus:@"Please Wait...."];
        NSString *string = [NSString stringWithFormat:@"&email=%@&password=%@&mode=driver&device_token=%@",self.userNameTextField.text,self.passwordTextField.text, deviceId];
        [[PApiCall sharedInstance] m_GetApiResponse:@"login" parameters:string onCompletion:^(NSDictionary *json)
        {
            NSDictionary *dic = (NSDictionary *)json;
            NSLog(@"%@", dic);
        if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
        {
        [SVProgressHUD showSuccessWithStatus:@"Done"];
        [[NSUserDefaults standardUserDefaults]setValue:[[dic valueForKey:@"data"] valueForKey:@"userid"] forKey:userId];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"loginDone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[PAppDelegate sharedAppDelegate] m_LoadHomeView];
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
            [SVProgressHUD showErrorWithStatus:@"Enter Valid EmailId."];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Enter The Required information."];
    }
}

- (IBAction)m_CreateAccounButtonPressed:(id)sender
{
    NSString *nibName=@"PSignUpViewController";
    if (IS_IPHONE5)
        nibName=@"PSignUpViewController_5";
    PSignUpViewController *signUpVC=[[PSignUpViewController alloc]initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:signUpVC animated:YES];
}

#pragma mark - TapGesture Method Implementation-
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}
#pragma mark - TextField Delegate-
#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
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
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
