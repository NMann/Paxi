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

@implementation PTaxiRequestVC{
       NSMutableData *webData;
        NSMutableArray *locationNameArray;
}
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
    webData=[[NSMutableData alloc]init];
    locationNameArray=[[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(m_SearchLocation:)
                                                name:UITextFieldTextDidChangeNotification object:self.locationTextField];

    [self m_AddNavigationBarItem];
    self.locationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
-(IBAction)m_SearchLocation:(id)sender
{
    if ([self.locationTextField.text length]>0)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@getLocations&keyword=%@",BaseURLString,self.locationTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *Request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSURLConnection  *Connection=[[NSURLConnection alloc]initWithRequest:Request delegate:self];
        NSLog(@"%@",Connection);
    }
}
#pragma mark-
#pragma mark - NSURL Connection  Delegate-

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //  NSString *strResult =[[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseDict=[NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingAllowFragments error:nil ];
    NSLog(@"%@",responseDict);
    if ([[responseDict objectForKey:@"data"] count] >0)
    {
        [locationNameArray removeAllObjects];
        [locationNameArray addObjectsFromArray:[[responseDict objectForKey:@"data"] valueForKey:@"locationname"]];
        
        [self.locationTableView setHidden:NO];
        [self.locationTableView reloadData];
        self.locationTableView.delegate =self;
        self.locationTableView.dataSource =self;
        [self.scrollView setContentOffset:CGPointMake(0, 170)];
     }else{
        [self.locationTableView setHidden:YES];
    }
    
}
#pragma mark - TextField Delegate-
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 170)];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0,0)];
    [textField resignFirstResponder];
    return YES;
}
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//     return YES;
//}

#pragma mark - MapView Delegate-
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 200,200);
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
-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.hidden = YES;
    
}
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [locationNameArray count];
    // return [locationNameArray count]+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     [self.locationTextField setText:[locationNameArray objectAtIndex:indexPath.row]] ;
    [self.locationTableView setHidden:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"Cell";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==Nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIImageView *pinImage=[[UIImageView alloc]init];
    pinImage.frame=CGRectMake(18, 11, 21, 27);
    [pinImage setImage:[UIImage imageNamed:@"pin"]];
    [cell.contentView addSubview:pinImage];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 220, 21)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0]];
    titleLabel.textColor=[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0];
    titleLabel.text=[locationNameArray objectAtIndex:indexPath.row];
   /* if ([locationNameArray count]>1 &&indexPath.row!=[locationNameArray count])
    {
        titleLabel.text=[locationNameArray objectAtIndex:indexPath.row];
    }*/
    [cell.contentView addSubview:titleLabel];
   
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
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
