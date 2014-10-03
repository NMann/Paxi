//
//  PRouteViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PRouteViewController.h"
#import "CustomAnnotation.h"
#import "PTaxiConfirmationVC.h"
#import <GoogleMaps/GoogleMaps.h>

@interface PRouteViewController ()

@end

@implementation PRouteViewController
{
    NSArray *path ;
    CLLocationCoordinate2D userCurrentLoc ;
    GMSMapView *googleMapView ;
    //   GMSMarker *marker ;
    
    Boolean noStartSet ;
    CLLocationCoordinate2D startPoint;
}

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
    noStartSet = TRUE ;
    [self m_AddNavigationBarItem];
    // Do any additional setup after loading the view from its nib.
    
    [self renderLocationView] ;
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
-(void)getMapRoute
{
    [googleMapView clear] ;
    NSLog(@"source: %@ destination: %@",self.strSourceAddress,self.strDestinationAddress) ;
    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true",self.strSourceAddress,self.strDestinationAddress];
    
    NSLog(@"url: %@",baseUrl) ;
    NSURL *url = [NSURL URLWithString:[baseUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSError *error = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSArray *routes = [result objectForKey:@"routes"];
        if(routes.count >0)
        {
            NSDictionary *firstRoute = [routes objectAtIndex:0];
            
            //Mark Annotation
            NSDictionary *leg =  [[firstRoute objectForKey:@"legs"] objectAtIndex:0];
            NSMutableArray *array = [[NSMutableArray alloc]initWithObjects:[[NSDictionary alloc]initWithObjectsAndKeys:[[leg valueForKey:@"start_location"] valueForKey:@"lat"],@"latitude",[[leg valueForKey:@"start_location"] valueForKey:@"lng"],@"longitude", [leg valueForKey:@"start_address"],@"type", nil],
                                     [[NSDictionary alloc]initWithObjectsAndKeys:[[leg valueForKey:@"end_location"] valueForKey:@"lat"],@"latitude",[[leg valueForKey:@"end_location"] valueForKey:@"lng"],@"longitude",[leg valueForKey:@"end_address"],@"type", nil]
                                     ,nil];
            
            [self focusMapToShowAllMarkers:array];
            
            //Format Time
            float totalSeconds = [[[leg objectForKey:@"duration"] objectForKey:@"value"] floatValue] ;
            int minTime = round(totalSeconds-120);
            int maxTime =round(totalSeconds+120) ;
            self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[self formatTravelTime:minTime],[self formatTravelTime:maxTime]] ;
            
            //Draw Route
            NSDictionary *overView = [firstRoute objectForKey:@"overview_polyline"];
            NSString *overview_route = [overView objectForKey:@"points"];
            GMSPath *mappath = [GMSPath pathFromEncodedPath:overview_route];
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:mappath];
            polyline.strokeColor = [UIColor redColor];
            polyline.strokeWidth = 3 ;
            polyline.map = googleMapView ;
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

#pragma mark GoogleMaps Methods
-(void)renderLocationView
{
    self.navigationItem.title = @"Location" ;
    [self.navigationController setNavigationBarHidden:NO] ;
    
    
    // render GoogleMap View
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                            longitude:151.2086
                                                                 zoom:12];
    googleMapView = [GMSMapView mapWithFrame:self.m_mapViewContainer.bounds camera: camera];
    googleMapView.settings.compassButton = YES;
    googleMapView.settings.myLocationButton = YES;
    googleMapView.delegate = self ;
    googleMapView.userInteractionEnabled = YES ;
    
    [googleMapView addObserver:self
                    forKeyPath:@"myLocation"
                       options:NSKeyValueObservingOptionNew
                       context:NULL];
    
    [self.m_mapViewContainer addSubview:googleMapView] ;
    dispatch_async(dispatch_get_main_queue(), ^{
        googleMapView.myLocationEnabled = YES;
        [self getMapRoute] ;
    });
    
    
}

#pragma mark - KVO updates
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    CLLocationCoordinate2D coords = location.coordinate ;
}

- (void)focusMapToShowAllMarkers:(NSMutableArray*)array
{
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
    CLLocationCoordinate2D location;
    for (NSDictionary *dictionary in array)
    {
        location.latitude = [dictionary[@"latitude"] floatValue];
        location.longitude = [dictionary[@"longitude"] floatValue];
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.icon = [UIImage imageNamed:(@"marker.png")];
        marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
        bounds = [bounds includingCoordinate:marker.position];
        marker.title = dictionary[@"type"];
        marker.map = googleMapView;
    }
    [googleMapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];
}


@end
