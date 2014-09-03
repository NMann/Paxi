//
//  PRouteViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PRouteViewController.h"
#import "PSummaryVC.h"
#import "CustomAnnotation.h"
@interface PRouteViewController ()

@end

@implementation PRouteViewController

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
    self.mapView.userInteractionEnabled = YES ;
    self.mapView.showsUserLocation = NO ;
    [self m_AddNavigationBarItem];
    [self renderMapView] ;
    // Do any additional setup after loading the view from its nib.
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
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
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
- (IBAction)m_DetailButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailViewFrame=self.detailView.frame;
        detailViewFrame.origin.y=detailViewFrame.origin.y-detailViewFrame.size.height-104;
        self.detailView.frame=detailViewFrame;
        self.m_routeDetailButton.alpha = 0 ;
    } completion:^(BOOL finished) {
        
    }];
}
- (IBAction)downButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailViewFrame=self.detailView.frame;
        detailViewFrame.origin.y=detailViewFrame.origin.y+detailViewFrame.size.height+104;
        self.detailView.frame=detailViewFrame;
        self.m_routeDetailButton.alpha = 1 ;
    } completion:^(BOOL finished) {
    }];
}
- (IBAction)m_SendButtonPressed:(id)sender{
    
    
    NSString *requestBody=[NSString stringWithFormat:@"&userid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId]];
    if ([self.strSourceAddress length]>0 &&(NSNull*)self.strSourceAddress!=[NSNull null])
    {
        requestBody=[NSString stringWithFormat:@"%@&souress_address=%@",requestBody,self.strSourceAddress];
    }
    else
        requestBody=[NSString stringWithFormat:@"%@&souress_address=",requestBody];
    if ([self.strDestinationAddress length]>0) {
        requestBody=[NSString stringWithFormat:@"%@&destination_address=%@",requestBody,self.strDestinationAddress];
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
             //   PTaxiConfirmationVC *routeVC=[[PTaxiConfirmationVC alloc] initWithNibName:@"PTaxiConfirmationVC" bundle:nil];
             // [self.navigationController pushViewController:routeVC animated:YES];
             
         }
         else if (![[json objectForKey:@"result"] isEqualToString:@"success"] &&[json objectForKey:@"error"]==nil)
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"data"]];
         }
         else
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         
     }];
    //  PTaxiConfirmationVC *routeVC=[[PTaxiConfirmationVC alloc] initWithNibName:@"PTaxiConfirmationVC" bundle:nil];
    //  [self.navigationController pushViewController:routeVC animated:YES];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods
-(void)renderMapView
{
    /*CLLocationCoordinate2D destinationCoords  =CLLocationCoordinate2DMake(40.643236,-73.790839);
     MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
     MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
     CLLocationCoordinate2D sourceCoords =  CLLocationCoordinate2DMake(40.693304,  -74.174745);
     MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(sourceCoords, 5000.0, 5000.0) ;
     [self.mapView setRegion:region animated:YES] ;
     
     MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];*/
    
    CLLocationCoordinate2D destinationCoords  = [self getLocationFromAddressString:self.strDestinationAddress] ;
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    CLLocationCoordinate2D sourceCoords  =  [self getLocationFromAddressString:self.strSourceAddress] ;
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    [self addCustomAnnotation:sourceCoords withAddress:self.strSourceAddress] ;
    
    //MkDirection Request
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
                 [self.mapView addOverlay:route.polyline] ;
             }
             //  [self.mapView addOverlay:route.polyline level:MKOverlayLevelAboveRoads];
         }
         else
         {
             NSLog(@"Error %@",error) ;
         }
     }];
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

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
    renderer.strokeColor = [UIColor redColor];
    renderer.lineWidth = 2.0;
    return renderer;
}

-(void)addCustomAnnotation:(CLLocationCoordinate2D)coords withAddress:(NSString*)address
{
    [self.mapView removeAnnotations:self.mapView.annotations] ;
    CustomAnnotation *customAnnotation = [[CustomAnnotation alloc]initWithTitle:address Location:coords] ;
    [self.mapView addAnnotation:customAnnotation] ;
}

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


@end
