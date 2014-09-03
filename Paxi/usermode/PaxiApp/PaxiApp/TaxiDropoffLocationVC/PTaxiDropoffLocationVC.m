//
//  PTaxiDropoffLocationVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 23/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PTaxiDropoffLocationVC.h"
#import "PTaxiConfirmationVC.h"
#import "PFavoriteAddressVC.h"
#import "PRouteViewController.h"

@interface PTaxiDropoffLocationVC ()

@end

@implementation PTaxiDropoffLocationVC

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

    [[PAppManager sharedData] m_AddPadding:self.addressTextField];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor whiteColor] textField:self.addressTextField];
    
   
    [self m_AddNavigationBarItem];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Drop-off Location";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    self.navigationItem.rightBarButtonItem=homeButton;
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
#pragma Mark - TextField Delegate-
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)m_SkipButtonPressed:(id)sender
{
    PTaxiConfirmationVC *taxiCinfirmationVC=[[PTaxiConfirmationVC alloc] initWithNibName:@"PTaxiConfirmationVC" bundle:nil];
    [self.navigationController pushViewController:taxiCinfirmationVC animated:YES];
}

- (IBAction)m_SendRequestButtonPressed:(id)sender
{

/*    NSString *requestBody=[NSString stringWithFormat:@"&userid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId]];
    if ([self.strSourceAddress length]>0 &&(NSNull*)self.strSourceAddress!=[NSNull null])
    {
        requestBody=[NSString stringWithFormat:@"%@&souress_address=%@",requestBody,self.strSourceAddress];
    }
    else
         requestBody=[NSString stringWithFormat:@"%@&souress_address=",requestBody];
    if ([self.addressTextField.text length]>0) {
        requestBody=[NSString stringWithFormat:@"%@&destination_address=%@",requestBody,self.addressTextField.text];
    }
    else
        requestBody=[NSString stringWithFormat:@"%@&destination_address=",requestBody];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance] m_GetApiResponse:@"taxiRequest" parameters:requestBody onCompletion:^(NSDictionary *json)
     {
         NSLog(@"%@",json);
         if ([[json objectForKey:@"result"] isEqualToString:@"success"] &&[json objectForKey:@"error"]==nil)
         {
           [SVProgressHUD showSuccessWithStatus:@"Request send successfully."];
             
             PRouteViewController *routeVC=[[PRouteViewController alloc] initWithNibName:@"PRouteViewController" bundle:nil];
                routeVC.strSourceAddress=self.strSourceAddress;
                routeVC.strSourceAddress=self.addressTextField;
             [self.navigationController pushViewController:routeVC animated:YES];
         }
         else if (![[json objectForKey:@"result"] isEqualToString:@"success"] &&[json objectForKey:@"error"]==nil)
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"data"]];
         }
         else
            [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         
    }];*/
    PRouteViewController *routeVC=[[PRouteViewController alloc] initWithNibName:@"PRouteViewController" bundle:nil];
    NSLog(@"source: %@ destination: %@",self.strSourceAddress,self.addressTextField.text) ;
    
    routeVC.strSourceAddress=self.strSourceAddress;
    routeVC.strDestinationAddress=self.addressTextField.text;
    [self.navigationController pushViewController:routeVC animated:YES];
}

- (IBAction)m_FavoriteButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"dropoff" forKey:@"FAVADD"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    PFavoriteAddressVC *favVC=[[PFavoriteAddressVC alloc]initWithNibName:@"PFavoriteAddressVC" bundle:nil];
    favVC.delegate=self;
    [self.navigationController pushViewController:favVC animated:YES];
}
-(void)addquestions:(NSString*)str
{
    self.addressTextField.text = str;
}
@end
