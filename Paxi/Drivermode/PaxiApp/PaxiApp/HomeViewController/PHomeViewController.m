//
//  PHomeViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PHomeViewController.h"
#import "PPassengerInfoViewController.h"
#import "PTaxiRequestVC.h"
#import "PPaxiViewController.h"
@interface PHomeViewController ()
{
    NSDateFormatter *dateFormat;
}
@end

@implementation PHomeViewController
@synthesize m_airportrequest ,m_taxirequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark- LifeCycle Method-
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    self.dateLabel.text=[dateFormat stringFromDate:[NSDate date]];
    self.locationLabel.text=[[NSUserDefaults standardUserDefaults]valueForKey:@"locationName"];
    
  
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /* DateFormat Initialization*/
    dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"MMMM d EEE"];

    [self m_CallwebserviceToGetRequests];
}

#pragma mark - Call Webservice to get airport Request-
-(void)m_CallwebserviceToGetRequests
{
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"getTotalDriverRequest" parameters:[NSString stringWithFormat:@"&driverid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId]] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
         NSLog(@"%@",json);
         if ([[json objectForKey:@"data"] count]>0&&[json objectForKey:@"error"]==nil)
         {
          airportrequests=[[json objectForKey:@"data"] valueForKey:@"total_airport_request"];
             if([airportrequests isEqualToString:@"0"]){
            }else{
                 [self showairportrequest];
             }
        
         taxirequests=[[json objectForKey:@"data"] valueForKey:@"total_taxi_request"];
         if([taxirequests isEqualToString:@"0"]){
             }else{
                 [self showtaxirequest];
             }
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
#pragma mark - to set airport request-

-(void) showairportrequest{
    [m_airportrequest setHidden:NO];
    m_airportrequest.layer.cornerRadius=10;
    m_airportrequest.layer.borderWidth= 1;
    m_airportrequest.layer.borderColor =  [UIColor whiteColor].CGColor;
    [m_airportrequest setTitle:airportrequests forState:UIControlStateNormal];
    
    CGSize stringsize = [m_airportrequest.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    [m_airportrequest setFrame:CGRectMake(m_airportrequest.frame.origin.x,m_airportrequest.frame.origin.y, stringsize.width>21?stringsize.width:21, 21)];
}

-(void)showtaxirequest{
    [m_taxirequest setHidden:NO];
    m_taxirequest.layer.cornerRadius=10;
    m_taxirequest.layer.borderWidth= 1;
    m_taxirequest.layer.borderColor =  [UIColor whiteColor].CGColor;
    [m_taxirequest setTitle:taxirequests forState:UIControlStateNormal];
    
    CGSize stringsize1 = [m_taxirequest.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:
                                                                                 [UIFont systemFontOfSize:13.0f]}];;
    [m_taxirequest setFrame:CGRectMake(m_taxirequest.frame.origin.x,m_taxirequest.frame.origin.y, stringsize1.width>21?stringsize1.width:21, 21)];
    
}

#pragma mark - Method Implementation-
- (IBAction)m_AirportButtonPressed:(id)sender
{
    PTaxiRequestVC *taxiRequestVC=[[PTaxiRequestVC alloc]initWithNibName:@"PTaxiRequestVC" bundle:nil];
    taxiRequestVC.isAirPort=YES;
    [self.navigationController pushViewController:taxiRequestVC animated:YES];
}

- (IBAction)m_TaxiRequestButtonPressed:(id)sender
{
    PTaxiRequestVC *taxiRequestVC=[[PTaxiRequestVC alloc]initWithNibName:@"PTaxiRequestVC" bundle:nil];
    taxiRequestVC.isAirPort=NO;
    [self.navigationController pushViewController:taxiRequestVC animated:YES];
}
- (IBAction)m_MyPaxiButtonPressed:(id)sender
{
    PPaxiViewController *paxiVC=[[PPaxiViewController alloc]initWithNibName:@"PPaxiViewController" bundle:nil];
    [self.navigationController pushViewController:paxiVC animated:YES];
}
#pragma mark - LifeCycle Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
