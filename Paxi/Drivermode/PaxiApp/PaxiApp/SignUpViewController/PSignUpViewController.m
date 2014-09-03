//
//  PSignUpViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignUpViewController.h"

@interface PSignUpViewController ()

@end

@implementation PSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark -LifeCycle Method-
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    /* Show Navigation Bar*/
    self.navigationController.navigationBarHidden=NO;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*circular Image*/
    self.profileImageView.layer.cornerRadius=40.0;
    self.imageBorderButton.layer.cornerRadius=40.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=2.0;
    
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    [self.scrollView addGestureRecognizer:tapGesture];

    /* Add Padding in Text Field*/
    [self m_AddPadding:self.nameTextField];
    [self m_AddPadding:self.userNameTextField];
    [self m_AddPadding:self.mobileTextField];
    [self m_AddPadding:self.emailTextField];
    [self m_AddPadding:self.passwordTextField];
    
    /*Method To add Navigation Bar item*/
    [self m_AddNavigationBarItem];
    // Do any additional setup after loading the view from its nib.
}
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Sign Up";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    backButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=backButton;
}
#pragma mark - Method Implementation-
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - Sign Up Button Pressed-
- (IBAction)m_SignupButtonPressed:(id)sender
{
    
}
#pragma mark - Tap Gesture Implementation-
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}
#pragma mark - Method To Add Padding-
-(void)m_AddPadding:(UITextField*)Sender
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    Sender.leftView = paddingView;
    Sender.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.text.length>0)
    {
        textField.text=@"";
    }
    [self.scrollView setContentOffset:CGPointMake(0,100) animated:YES];
    if ([textField tag]>=4) {
        [self.scrollView setContentOffset:CGPointMake(0,180) animated:YES];

    }
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
        if ([textField tag]>=4) {
            [self.scrollView setContentOffset:CGPointMake(0,180) animated:NO];
            
        }
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
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
