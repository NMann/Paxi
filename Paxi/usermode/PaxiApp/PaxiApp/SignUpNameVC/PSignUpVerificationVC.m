//
//  PSignUpVerificationVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignUpVerificationVC.h"
#import "PSignUpEmailVC.h"
@interface PSignUpVerificationVC ()

@end

@implementation PSignUpVerificationVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[PAppManager sharedData] m_AddPadding:self.verificationCodeTextField];
    /* ChangePlaceHolder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.verificationCodeTextField];
    /*Add Swipe Gesture*/
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_SwipeGesture:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark- Swipe Gesture Implementation-
-(void)m_SwipeGesture:(UISwipeGestureRecognizer*)sender
{
    if ([sender state]==UIGestureRecognizerStateRecognized)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Method Implementation-
- (IBAction)m_NextButtonPressed:(id)sender
{
    PSignUpEmailVC *emailVC=[[PSignUpEmailVC alloc]initWithNibName:@"PSignUpEmailVC" bundle:nil];
    [self.navigationController pushViewController:emailVC animated:YES];
    
}



#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.text.length>0)
    {
        textField.text=@"";
    }
    [self.scrollView setContentOffset:CGPointMake(0,120) animated:YES];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 120)];
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
#pragma mark - MEmory Management MEthod-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
