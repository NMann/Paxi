//
//  PAirportConfirmatioVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PAirportConfirmationVC.h"
#import "PEvaluationVC.h"
#import "PSignatureVC.h"
@interface PAirportConfirmationVC ()

@end

@implementation PAirportConfirmationVC
@synthesize meetingTextField;


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
    self.sourceAddressLabel.text=self.strSourceAddress;
    if ([self.strDestinationAddress length]>0 && (NSNull*)self.strDestinationAddress!=[NSNull null] && ![self.strDestinationAddress isKindOfClass:[NSNull class]])
    {
        self.destinationAddressLabel.text=self.strDestinationAddress;
    }
    else
        self.destinationAddressLabel.text=@"";
    
    if ([self.strBasicFee length]>0 && (NSNull*)self.strBasicFee!=[NSNull null] && ![self.strBasicFee isKindOfClass:[NSNull class]])
    {
        self.basicFeeLabel.text=self.strBasicFee;
    }
    else
        self.basicFeeLabel.text=@"";
    if ([self.strAirportCharges length]>0 && (NSNull*)self.strAirportCharges!=[NSNull null] && ![self.strAirportCharges isKindOfClass:[NSNull class]])
    {
        self.airportServiceLabel.text=self.strAirportCharges;
    }
    else
        self.airportServiceLabel.text=@"";
    if ([self.strTotalFee length]>0 && (NSNull*)self.strTotalFee!=[NSNull null] && ![self.strTotalFee isKindOfClass:[NSNull class]])
    {
        self.totalFeeLabel.text=self.strTotalFee;
    }
    else
        self.totalFeeLabel.text=@"";
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView setContentSize:CGSizeMake(320, 352)];
    // Do any additional setup after loading the view from its nib.
    [self m_AddNavigationBarItem];

    //[[NSNotificationCenter defaultCenter] addObserver:self    selector:@selector(PEvaluation)name:@"evaluation" object:nil];
  
       /*Add Padding*/
    [[PAppManager sharedData] m_AddPadding:self.meetingTextField];
 
    /* change Place Holder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0] textField:self.meetingTextField];


}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Confirmation";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    self.navigationItem.rightBarButtonItem=homeButton;
}
-(void)PEvaluation{
        PEvaluationVC *evaluationVC=[[PEvaluationVC alloc]initWithNibName:@"PEvaluationVC" bundle:nil];
        [self.navigationController pushViewController:evaluationVC animated:YES];
}
#pragma mark - Method Implementation-
-(IBAction)m_HomeButtonPressed:(id)sender
{
  [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)m_SendRequestButtonPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please wait..."];
   
    
    NSData *imageData=UIImageJPEGRepresentation([self.signatureButton currentBackgroundImage], 1.0);
   NSString *imageurl=[[PApiCall sharedInstance]uploadimage:imageData];
    if ([imageurl length]>0)
    {
        [self sendRequest:[NSString stringWithFormat:@"&requestid=%@&img=%@",self.strId,imageurl]];
    }
  else
  {
      [SVProgressHUD showErrorWithStatus:@"Try Again"];
  }
    
   PEvaluationVC *evaluationVC=[[PEvaluationVC alloc]initWithNibName:@"PEvaluationVC" bundle:nil];
   [self.navigationController pushViewController:evaluationVC animated:YES];
}
-(void)sendRequest:(NSString*)parameter
{
    [[PApiCall sharedInstance] m_GetApiResponse:@"sendRequest" parameters:parameter onCompletion:^(NSDictionary *json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"%@", dic);
        if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
        {
            [SVProgressHUD showSuccessWithStatus:@"Request Send Successfully."];
        }else if ([[dic valueForKey:@"return"] integerValue]==0)
            {
                [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"data"]];
                
            }
            else
            {
                [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
            }
    }];
}
- (IBAction)m_SignatureButtonPressed:(id)sender
{
    PSignatureVC *signatureVC=[[PSignatureVC alloc] initWithNibName:@"PSignatureVC" bundle:nil];
    signatureVC.delegate=self;
    UINavigationController *objNav=[[UINavigationController alloc]initWithRootViewController:signatureVC];
    [self presentViewController:objNav animated:YES completion:nil];
}

- (IBAction)m_EditButtonPressed:(id)sender
{
    PSignatureVC *signatureVC=[[PSignatureVC alloc] initWithNibName:@"PSignatureVC" bundle:nil];
    signatureVC.delegate=self;
    UINavigationController *objNav=[[UINavigationController alloc]initWithRootViewController:signatureVC];
    [self presentViewController:objNav animated:YES completion:nil];
}

- (IBAction)m_DoneButtonPressed:(id)sender
{
}


-(void)SignatureImage:(UIImage*)image
{
    [self.signatureButton setBackgroundImage:image forState:UIControlStateNormal];
}
#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0,250) animated:YES];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        [textField resignFirstResponder];
        return YES;
}

#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
