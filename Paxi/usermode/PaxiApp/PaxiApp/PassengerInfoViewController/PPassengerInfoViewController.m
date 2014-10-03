//
//  PPassengerInfoViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PPassengerInfoViewController.h"
#import "PLocationVC.h"
#import "PTaxiRequestVC.h"
@interface PPassengerInfoViewController ()

@end

@implementation PPassengerInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - LifeCycle Method-
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden=YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ispickerShow=NO;
    [self m_AddNavigationBarItem];
    /*Add Padding*/
    [[PAppManager sharedData] m_AddPadding:self.flightNoTextField];
    [[PAppManager sharedData] m_AddPadding:self.destinationTextField];
    [[PAppManager sharedData] m_AddPadding:self.passengerNameTextField];
    /* change Place Holder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0] textField:self.flightNoTextField];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0] textField:self.destinationTextField];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0] textField:self.passengerNameTextField];
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    [self.scrollView addGestureRecognizer:tapGesture];
      // Do any additional setup after loading the view from its nib.
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
  
    self.navigationItem.title=@"Passenger Information";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    self.navigationItem.rightBarButtonItem=homeButton;
}
#pragma mark - Tap Gesture Implementation-
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

#pragma mark - Method Implementation-
-(IBAction)m_HomeButtonPressed:(id)sender
{
   [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)m_TaxiButtonPressed:(id)sender
{
    self.tabBarController.selectedIndex=1;
//    PTaxiRequestVC *taxiRequestVC=[[PTaxiRequestVC alloc]initWithNibName:@"PTaxiRequestVC" bundle:nil];
//    [self.navigationController pushViewController:taxiRequestVC animated:NO];

}
- (IBAction)m_ActivitiesButtonPressed:(id)sender
{
}
- (IBAction)m_MyPaxiButtonPressed:(id)sender
{
    self.tabBarController.selectedIndex=2;
}
- (IBAction)m_DateSelected:(id)sender
{
   [self.scrollView setContentOffset:CGPointMake(0,0)];
    self.date=[[PAppManager sharedData] m_Getdate:[sender date]];
   // [self.departureDateButton setTitle:self.date forState:UIControlStateNormal];
}
- (IBAction)m_PickUpButtonPressed:(id)sender
{
    self.tabBarController.selectedIndex=0;
}
- (IBAction)m_CancelButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        ispickerShow=NO;
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        CGRect dateViewFrame=self.pickerView.frame;
        dateViewFrame.origin.y=dateViewFrame.origin.y+dateViewFrame.size.height;
        self.pickerView.frame=dateViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)m_Done:(id)sender
{
    [self.departureDateButton setTitle:self.date forState:UIControlStateNormal];
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    [UIView animateWithDuration:0.3 animations:^{
        ispickerShow=NO;
        CGRect dateViewFrame=self.pickerView.frame;
        dateViewFrame.origin.y=dateViewFrame.origin.y+dateViewFrame.size.height;
        self.pickerView.frame=dateViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}


- (IBAction)m_DepartureDateButtonPressed:(id)sender
{
    if (ispickerShow==NO)
    {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect dateViewFrame=self.pickerView.frame;
            dateViewFrame.origin.y=dateViewFrame.origin.y-dateViewFrame.size.height;
            self.pickerView.frame=dateViewFrame;
            ispickerShow=YES;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (IBAction)m_LocationButtonPressed:(id)sender
{
    if ([self.destinationTextField.text length]>0&&[self.flightNoTextField.text length]>0 &&[self.passengerNameTextField.text length]>0 &&[[self.departureDateButton currentTitle] length]>0 && ![[self.departureDateButton currentTitle] isEqualToString:@"Departure Date"])
    {
        PLocationVC *locationVC=[[PLocationVC alloc]initWithNibName:@"PLocationVC" bundle:nil];
        locationVC.strDepartureDate=[self.departureDateButton currentTitle];
        locationVC.strDestination=self.destinationTextField.text;
        locationVC.strFlightNo=self.flightNoTextField.text;
        locationVC.strPassengerName=self.passengerNameTextField.text;
        [self.navigationController pushViewController:locationVC animated:YES];
    }
   else
   {
       [SVProgressHUD showErrorWithStatus:@"Please Enter The Required Detail."];
   }
}


#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField.tag==2)
        [self.scrollView setContentOffset:CGPointMake(0,30) animated:YES];
    else if (textField.tag==3)
        [self.scrollView setContentOffset:CGPointMake(0,60) animated:YES];
    else if (textField.tag==4)
        [self.scrollView setContentOffset:CGPointMake(0,60) animated:YES];
 
        return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    

    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        if (nextTag>1&&nextTag<4)
        {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y+30)];
            
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
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

@end
