//
//  PPassengerInfoVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PPassengerInfoVC.h"
#import "PRouteViewController.h"
#import "CustomAnnotation.h"
@interface PPassengerInfoVC ()

@end

@implementation PPassengerInfoVC

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
   
    if (![self.taxiRequestDetail.strSourceAddress isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strSourceAddress!=[NSNull null] &&[self.taxiRequestDetail.strSourceAddress length]>0)
    {
        self.locationLabel.text=self.taxiRequestDetail.strSourceAddress;
    }
    if (![self.taxiRequestDetail.strDestinationAddress isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strDestinationAddress!=[NSNull null] &&[self.taxiRequestDetail.strDestinationAddress length]>0)
    {
       // self.destinationAddressLabel.text=self.taxiRequestDetail.strDestinationAddress;
    }
    
    if (![self.taxiRequestDetail.strUserImage isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strUserImage!=[NSNull null] &&[self.taxiRequestDetail.strUserImage length]>0)
    {
        [self.profileImageView setImageWithURL:[NSURL URLWithString:self.taxiRequestDetail.strUserImage] placeholderImage:[UIImage imageNamed:@"img.png"]];
        
    }
    if (![self.taxiRequestDetail.strUserName isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strUserName!=[NSNull null] &&[self.taxiRequestDetail.strUserName length]>0)
    {
        self.nameLabel.text=self.taxiRequestDetail.strUserName;
    }
     [self renderMapView] ;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageBorderButton.layer.cornerRadius=25.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=1.0;
    self.profileImageView.layer.cornerRadius=25.0;
    [self m_AddNavigationBarItem];
    
}
#pragma mark -Custom Method
-(void)renderMapView
{
    CLLocationCoordinate2D destinationCoords  = [self getLocationFromAddressString:self.taxiRequestDetail.strDestinationAddress] ;
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    CLLocationCoordinate2D sourceCoords  =  [self getLocationFromAddressString:self.taxiRequestDetail.strSourceAddress] ;
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:[MKMapItem mapItemForCurrentLocation]];
    [request setSource:source] ;
    [request setDestination:destination];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    [request setRequestsAlternateRoutes:NO];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
     {
         if ( ! error && [response routes] > 0)
         {
             MKRoute *route = [[response routes] objectAtIndex:0];
             NSLog(@"expectedTravelTime> %f distance: %f transportType: %u",route.expectedTravelTime,route.distance,route.transportType) ;
             if(round(route.expectedTravelTime) != 0)
             {
                 int minTime = round(route.expectedTravelTime-120);
                 int maxTime =round(route.expectedTravelTime+120) ;
                 NSLog(@"min: %d max: %d",minTime,maxTime) ;
                 self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[self formatTravelTime:minTime],[self formatTravelTime:maxTime]] ;
             }
         }
         else
         {
             NSLog(@"Error %@",error) ;
         }
     }];
}

#pragma mark -Method To Add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Routes";
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
- (IBAction)m_CallButtonPressed:(id)sender
{
//    if (![self.taxiRequestDetail.strUserPhone isKindOfClass:[NSNull class]]&&(NSNull*)self.taxiRequestDetail.strUserPhone!=[NSNull null] &&[self.taxiRequestDetail.strUserPhone length]>0)
//    {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.taxiRequestDetail.strUserPhone]]];
  // }
}

- (IBAction)m_TextButtonPressed:(id)sender
{

    MFMessageComposeViewController *messageVC = [[MFMessageComposeViewController alloc] init];
    if([MFMessageComposeViewController canSendText])
    {
    messageVC.body = @"Enter a message";
    messageVC.recipients = @[@"Telnumber"];
    messageVC.messageComposeDelegate = self;
    [self presentViewController:messageVC animated:NO completion:NULL];
    }
}

- (IBAction)downButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailViewFrame=self.detailView.frame;
        detailViewFrame.origin.y=detailViewFrame.origin.y+detailViewFrame.size.height+104;
        self.detailView.frame=detailViewFrame;
        self.detailInfoButton.alpha = 1 ;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)m_StartButtonPressed:(id)sender
{
   [SVProgressHUD showWithStatus:@"Please wait..."];
    NSString *string = [NSString stringWithFormat:@"&driverid=%@&requestid=%@&source_address=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId] ,self.taxiRequestDetail.strRequestId  ,self.taxiRequestDetail.strSourceAddress];
    
    NSLog(@"string is %@", string);
    [[PApiCall sharedInstance]m_GetApiResponse:@"departureTaxi" parameters:string onCompletion:^(NSDictionary *json) {
        [SVProgressHUD showSuccessWithStatus:@"Done"];
        NSLog(@"%@",json);
        if ([[json objectForKey:@"result"] isEqualToString:@"success"])
        {
            PRouteViewController *routeVC=[[PRouteViewController alloc]initWithNibName:@"PRouteViewController" bundle:nil];
            routeVC.taxiRequestDetail=self.taxiRequestDetail;
            [self.navigationController pushViewController:routeVC animated:YES];
            
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

- (IBAction)m_DetailButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailViewFrame=self.detailView.frame;
        detailViewFrame.origin.y=detailViewFrame.origin.y-detailViewFrame.size.height-104;
        self.detailView.frame=detailViewFrame;
        self.detailInfoButton.alpha = 0 ;
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark - Message view delegate-
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    switch (result) {
        case MessageComposeResultCancelled:
           // NSLog(@"Message was cancelled");
            [SVProgressHUD showErrorWithStatus:@"Message was cancelled"];
            [self dismissViewControllerAnimated:YES completion:NULL];             break;
        case MessageComposeResultFailed:
           // NSLog(@"Message failed");
            [SVProgressHUD showErrorWithStatus:@"Message failed"];
            [self dismissViewControllerAnimated:YES completion:NULL];             break;
        case MessageComposeResultSent:
           // NSLog(@"Message was sent");
             [SVProgressHUD showErrorWithStatus:@"Message was sent"];
            [self dismissViewControllerAnimated:YES completion:NULL];             break;
        default:             
            break;     
    } 
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MapView Utility Methods
-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

-(NSString *)formatTravelTime:(NSInteger)totalSeconds
{
    //int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    if(hours != 0)
    {
        return [NSString stringWithFormat:@"%dh %dm",hours, minutes];
    }
    else
    {
        return [NSString stringWithFormat:@"%dm", minutes];
    }
    
}

#pragma mark - Map View Delegate Method
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D cords = mapView.userLocation.location.coordinate ;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(cords, 1000.0, 1000.0) ;
    [mapView setRegion:region animated:YES] ;
    
    CustomAnnotation *customAnnotation = [[CustomAnnotation alloc]initWithTitle:self.taxiRequestDetail.strSourceAddress Location:cords] ;
    [mapView addAnnotation:customAnnotation] ;
    
    mapView.showsUserLocation = NO ;
    
}

-(MKAnnotationView*)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // NSLog(@"viewForAnnotation ") ;
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

@end
