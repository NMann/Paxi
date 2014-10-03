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
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (strong, nonatomic) CLLocation *currentLocation;
@end

@implementation PHomeViewController

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
    [self reverseGeocodeLocation];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /* DateFormat Initialization*/
    
    
    if([CLLocationManager locationServicesEnabled])
    {
        locationManager = [[CLLocationManager alloc] init];
        geocoder = [[CLGeocoder alloc] init];
        locationManager.delegate = self;
        locationManager.pausesLocationUpdatesAutomatically=NO;
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter=kCLDistanceFilterNone;
        locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        [locationManager startUpdatingLocation];
    }
   
   
 //   cell.dateLabel.text=[[PAppManager sharedData] m_GetFormattedDate:newDate];
    self.dateLabel.text=[[PAppManager sharedData]m_GetFormattedDate:[NSDate date]];
    // Do any additional setup after loading the view from its nib.
}

- (void)reverseGeocodeLocation
{
   
[geocoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *placemarks, NSError *error)
 {

if(placemarks.count){
    NSDictionary *dictionary = [[placemarks objectAtIndex:0] addressDictionary];
    
    [self.locationNameLabel setText:[dictionary valueForKey:@"City"]];
}
}];
    
}
#pragma mark - Method Implementation-
- (IBAction)m_AirportButtonPressed:(id)sender
{
    [self m_LoadTabBar:0];
//    PPassengerInfoViewController *passengerInfoVC=[[PPassengerInfoViewController alloc]initWithNibName:@"PPassengerInfoViewController" bundle:nil];
//    [self.navigationController pushViewController:passengerInfoVC animated:YES];
}

- (IBAction)m_TaxiRequestButtonPressed:(id)sender
{
      [self m_LoadTabBar:1];
//    PTaxiRequestVC *taxiRequestVC=[[PTaxiRequestVC alloc]initWithNibName:@"PTaxiRequestVC" bundle:nil];
//    [self.navigationController pushViewController:taxiRequestVC animated:YES];
}
-(void)m_LoadTabBar:(int)selectedTab
{
    PPassengerInfoViewController *passengerInfoVC=[[PPassengerInfoViewController alloc]initWithNibName:@"PPassengerInfoViewController" bundle:nil];
    UINavigationController *navPassengerInfo=[[UINavigationController alloc]initWithRootViewController:passengerInfoVC];
    
    PTaxiRequestVC *taxiRequestVC=[[PTaxiRequestVC alloc]initWithNibName:@"PTaxiRequestVC" bundle:nil];
   UINavigationController *navTaxiRequestInfo=[[UINavigationController alloc]initWithRootViewController:taxiRequestVC];
    
    PPaxiViewController *paxiVC=[[PPaxiViewController alloc]initWithNibName:@"PPaxiViewController" bundle:nil];
    UINavigationController *navPaxi=[[UINavigationController alloc]initWithRootViewController:paxiVC];
    
    UITabBarController *tabBar=[[UITabBarController alloc]init];
    [tabBar setViewControllers:[NSArray arrayWithObjects:navPassengerInfo,navTaxiRequestInfo,navPaxi, nil]];
    tabBar.selectedIndex=selectedTab;
    [self presentViewController:tabBar animated:NO completion:nil];
}
- (IBAction)m_MyPaxiButtonPressed:(id)sender
{
    [self m_LoadTabBar:2];
//    PPaxiViewController *paxiVC=[[PPaxiViewController alloc]initWithNibName:@"PPaxiViewController" bundle:nil];
//    [self.navigationController pushViewController:paxiVC animated:YES];
}
- (IBAction)m_ActivitiesButtonPressed:(id)sender
{
}
#pragma mark - MapView delegate-
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
//    CLLocation *currentLocation = [locations lastObject];
    [self reverseGeocodeLocation];

}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
