//
//  PPaxiViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PPaxiViewController.h"
#import "PMyProfileVC.h"
#import "PMyAccountViewController.h"
@interface PPaxiViewController ()

@end

@implementation PPaxiViewController

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
    [self m_GetProfileInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationName = [[NSUserDefaults standardUserDefaults] valueForKey:@"locationName"];

    self.profileImage.layer.cornerRadius=35.0;
    self.imageBorderButton.layer.cornerRadius=35.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=2.0;
    
    [self m_AddNavigationBarItem];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Method To Add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"My Paxi";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    backButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    homeButton.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=homeButton;
}
#pragma mark - Method Implementation-
-(IBAction)m_HomeButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)m_MyProfileButtonPressed:(id)sender
{
    PMyProfileVC *myProfileVC=[[PMyProfileVC alloc]initWithNibName:@"PMyProfileVC" bundle:nil];
    [self.navigationController pushViewController:myProfileVC animated:YES];
}

- (IBAction)m_MyAccountButtonPressed:(id)sender
{
   PMyAccountViewController *myAccountVC=[[PMyAccountViewController alloc]initWithNibName:@"PMyAccountViewController" bundle:nil];
   [self.navigationController pushViewController:myAccountVC animated:YES];
}

- (IBAction)m_LogOffButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"loginDone"];
    [[PAppDelegate sharedAppDelegate]m_loadLoginView];

}
#pragma mark- Method To get Profile Info-
-(void)m_GetProfileInfo
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"showProfile" parameters:[NSString stringWithFormat:@"&userid=%@&mode=driver",[[NSUserDefaults standardUserDefaults]valueForKey:userId]] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
         NSDictionary *dic=json;
         NSLog(@"%@",dic);
         if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
         {
             self.nameLabel.text=[[dic valueForKey:@"data"] valueForKey:@"username"];
             self.locationLabel.text= locationName ;
             self.ratingLabel.text=[[dic valueForKey:@"data"] valueForKey:@"rating"];
             if ([[[dic valueForKey:@"data"] valueForKey:@"userimage"] length])
             {
                 self.profileImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[dic valueForKey:@"data"] valueForKey:@"userimage"]]]];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         }
     }];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
