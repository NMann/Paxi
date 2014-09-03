//
//  PTaxiRequestVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 17/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PTaxiRequestVC.h"
#import "PPassengerInfoViewController.h"
#import "PTaxiDropoffLocationVC.h"
#import "PFavoriteaddressVC.h"
#import "CustomAnnotation.h"

@interface PTaxiRequestVC ()

@end

@implementation PTaxiRequestVC
@synthesize locationTextField;

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
    self.tabBarController.tabBar.hidden=YES;
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self.scrollView setContentSize:CGSizeMake(320, 424)];
    [[PAppManager sharedData] m_AddPadding:self.locationTextField];
    [self m_AddNavigationBarItem];
    
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Pick-up Location";
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
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (IBAction)m_PickupButtonPressed:(id)sender
{
    //    PPassengerInfoViewController *passengerInfoVC=[[PPassengerInfoViewController alloc]initWithNibName:@"PPassengerInfoViewController" bundle:nil];
    //    [self.navigationController pushViewController:passengerInfoVC animated:NO];
    self.tabBarController.selectedIndex=0;
}


- (IBAction)m_DoneButtonPressed:(id)sender
{
    if([locationTextField.text  length ]>0 ){
        PTaxiDropoffLocationVC *dropoffLocationVC=[[PTaxiDropoffLocationVC alloc]initWithNibName:@"PTaxiDropoffLocationVC" bundle:nil];
        dropoffLocationVC.strSourceAddress=self.locationTextField.text;
        [self.navigationController pushViewController:dropoffLocationVC animated:YES];
        
    }else{
        [SVProgressHUD showErrorWithStatus:@"Fields are required"];
    }
}

- (IBAction)m_FavoritesButtonPressed:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setObject:@"pickup" forKey:@"FAVADD"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    PFavoriteAddressVC *favVC=[[PFavoriteAddressVC alloc]initWithNibName:@"PFavoriteAddressVC" bundle:nil];
    favVC.delegate=self;
    [self.navigationController pushViewController:favVC animated:YES];
    
}

- (IBAction)m_TaxiButtonPressed:(id)sender
{
    self.tabBarController.selectedIndex=1;
}

- (IBAction)m_MyPaxiButtonPressed:(id)sender
{
    self.tabBarController.selectedIndex=2;
}
#pragma mark - TextField Delegate-
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 160)];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - MapView Delegate-
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 500,500);
    [self.mapView setRegion:region animated:YES];
    [self addCustomAnnotation:loc withAddress:@"Test"] ;
}


-(void)addCustomAnnotation:(CLLocationCoordinate2D)coords withAddress:(NSString*)address
{
    [self.mapView removeAnnotations:self.mapView.annotations] ;
    CustomAnnotation *customAnnotation = [[CustomAnnotation alloc]initWithTitle:address Location:coords] ;
    [self.mapView addAnnotation:customAnnotation] ;
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[CustomAnnotation class]])
    {
        CustomAnnotation *customAnnotation = (CustomAnnotation*)annotation ;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomAnnotation"] ;
        if(annotationView == nil)
        {
            annotationView = customAnnotation.annotationView ;
        }
        else
        {
            annotationView.annotation = annotation ;
        }
        return annotationView ;
    }
    else{
        return nil ;
    }
}


#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addquestions:(NSString*)str
{
    self.locationTextField.text = str;
}

@end
