//
//  PSummaryVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSummaryVC.h"

@interface PSummaryVC ()

@end

@implementation PSummaryVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - Life Cycle Method-

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    if (![self.taxiRequestDetail.strSourceAddress isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strSourceAddress!=[NSNull null] &&[self.taxiRequestDetail.strSourceAddress length]>0)
    {
        self.pickupLocationLabel.text=self.taxiRequestDetail.strSourceAddress;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self m_AddNavigationBarItem];
    [self.scrollView setContentSize:CGSizeMake(320, 300)];
    self.profileIMageView.layer.cornerRadius=25.0;
    self.imageBorderButton.layer.cornerRadius=25.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=2.0;
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Method To add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Summary";
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
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)finishButtonPressed:(id)sender {
    [SVProgressHUD showWithStatus:@"Please wait..."];
    NSString *string = [NSString stringWithFormat:@"&requestid=%@&driverid=%@",self.taxiRequestDetail.strRequestId,[[NSUserDefaults standardUserDefaults]valueForKey:userId] ];
    
    NSLog(@"string is %@", string);
    [[PApiCall sharedInstance]m_GetApiResponse:@"finishedTaxiRequest" parameters:string onCompletion:^(NSDictionary *json) {
        [SVProgressHUD showSuccessWithStatus:@"Done"];
        NSLog(@" json is  %@",json);
        if ([[json objectForKey:@"result"] isEqualToString:@"success"])
        {
           [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
        else if ([[json objectForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
        {
          
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
        }
    }];
}
@end
