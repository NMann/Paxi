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

@implementation PPassengerInfoVC{
    NSArray *path ;
    CLLocationCoordinate2D userCurrentLoc ;
    GMSMapView *googleMapView ;
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
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageBorderButton.layer.cornerRadius=25.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=1.0;
    self.profileImageView.layer.cornerRadius=25.0;
    [self m_AddNavigationBarItem];
   
    [self renderLocationView];
    
}
#pragma mark Custom Methods
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
       [self getMapRoute];
    });
    
    
}

-(void)getMapRoute
{
    [googleMapView clear] ;

    NSString *baseUrl = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%@&destination=%@&sensor=true",self.taxiRequestDetail.strSourceAddress,self.taxiRequestDetail.strDestinationAddress];
    
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
            
            //Format Time
            float totalSeconds = [[[leg objectForKey:@"duration"] objectForKey:@"value"] floatValue] ;
            int minTime = round(totalSeconds-120);
            int maxTime =round(totalSeconds+120) ;
            self.timeLabel.text = [NSString stringWithFormat:@"%@ - %@",[self formatTravelTime:minTime],[self formatTravelTime:maxTime]] ;
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

-(NSString*)getCurrentLocationAddress:(CLLocationCoordinate2D)coords
{
    NSString *address ;
    NSString *urlString= [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false" ,coords.latitude,coords.longitude];
   NSString *newString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url=[NSURL URLWithString:newString];
    NSData *data=[NSData dataWithContentsOfURL:url];
    NSDictionary *json=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:Nil];
    NSArray *results = [json valueForKey:@"results"];
    if(results.count >0){
        address = [[results objectAtIndex:0] objectForKey:@"formatted_address"] ;
    }
    return address;
   }
#pragma mark - KVO updates
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
    CLLocationCoordinate2D coords = location.coordinate ;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.icon = [UIImage imageNamed:(@"marker.png")];
    marker.position = coords;
    marker.title =[self getCurrentLocationAddress:coords];
    marker.map = googleMapView;
    [googleMapView animateToLocation:coords];
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




@end
