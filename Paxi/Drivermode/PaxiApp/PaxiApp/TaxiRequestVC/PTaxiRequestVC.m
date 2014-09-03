//
//  PTaxiRequestVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PTaxiRequestVC.h"
#import "PTaxiRequestCell.h"
#import "PPassengerInfoVC.h"
#import "PTaxiRequest.h"
#import "PPassengerInfoViewController.h"
@interface PTaxiRequestVC ()
{
    NSMutableArray *requestArray;
    NSDateFormatter *dateFormt;
}

@end

@implementation PTaxiRequestVC

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
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self m_AddNavigationBarItem];
    requestArray=[[NSMutableArray alloc]init];
    if (self.isAirPort==YES)
    {
        [self m_CallwebserviceToGetAirportRequest];
    }
    else
        [self m_CallWebserviceToGetTaxiRequest];
    
    dateFormt=[[NSDateFormatter alloc]init];
    [dateFormt setDateFormat:@"MMMM-dd-yyyy, h:mm a"];
    
}
#pragma mark -Method To Add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Taxi Requests";
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
    [self.navigationController popToRootViewControllerAnimated:NO];}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [requestArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"Cell";
    PTaxiRequestCell *cell=(PTaxiRequestCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PTaxiRequestCell" owner:self options:nil];
        
        cell=[nib objectAtIndex:0];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    if (self.isAirPort==YES)
            {
                PAirportRequest *request =[requestArray objectAtIndex:indexPath.row];
                if (![request.strDepartureDate isKindOfClass:[NSNull class]]&&(NSNull*)request.strDepartureDate!=[NSNull null] &&[request.strDepartureDate length]>0)
                {
                     cell.dateLabel.text=request.strDepartureDate;
                }
                if (![request.strFlightNo isKindOfClass:[NSNull class]]&&(NSNull*)request.strFlightNo!=[NSNull null] &&[request.strFlightNo length]>0)
                {
                    cell.timeLabel.text=request.strFlightNo;
                }
                
                
                if (![request.strSourceAddress isKindOfClass:[NSNull class]]&&(NSNull*)request.strSourceAddress!=[NSNull null] &&[request.strSourceAddress length]>0)
                {
                    cell.sourceAddressLabel.text=request.strSourceAddress;
                }
                if (![request.strDestinationAddress isKindOfClass:[NSNull class]]&&(NSNull*)request.strDestinationAddress!=[NSNull null] &&[request.strDestinationAddress length]>0)
                {
                    cell.destinationAdressLabel.text=request.strDestinationAddress;
                }
                
                if (![request.strUserImage isKindOfClass:[NSNull class]]&&(NSNull*)request.strUserImage!=[NSNull null] &&[request.strUserImage length]>0)
                {
                    [cell.profileImageView setImageWithURL:[NSURL URLWithString:request.strUserImage] placeholderImage:[UIImage imageNamed:@"img.png"]];
                    
                }
               
            }
           else
           {
                PTaxiRequest *request =[requestArray objectAtIndex:indexPath.row];
                if (![request.strDate isKindOfClass:[NSNull class]]&&(NSNull*)request.strDate!=[NSNull null] &&[request.strDate length]>0)
                {
                    // cell.dateLabel.text=request.strDate;
                    //  cell.timeLabel.text= time;
                    
                    NSLog(@"str is %@ ",request.strDate);
                   NSDate *newDate=[dateFormt dateFromString:request.strDate];
                    NSLog(@"date is %@ ",newDate);
                    cell.dateLabel.text=[[PAppManager sharedData] m_GetFormattedDate:newDate];
                
                   NSDateFormatter  *timeFormt=[[NSDateFormatter alloc]init];
                    [timeFormt setDateFormat:@"h:mm a"];
                    NSString *newtime=[timeFormt stringFromDate:newDate];
                    NSLog(@"date is %@ ",newtime);
                 
                      cell.timeLabel.text= newtime;
                    
              
                    
                 }
                
                if (![request.strSourceAddress isKindOfClass:[NSNull class]]&&(NSNull*)request.strSourceAddress!=[NSNull null] &&[request.strSourceAddress length]>0)
                {
                    cell.sourceAddressLabel.text=request.strSourceAddress;
                }
                if (![request.strDestinationAddress isKindOfClass:[NSNull class]]&&(NSNull*)request.strDestinationAddress!=[NSNull null] &&[request.strDestinationAddress length]>0)
                {
                    cell.destinationAdressLabel.text=request.strDestinationAddress;
                }
                
                if (![request.strUserImage isKindOfClass:[NSNull class]]&&(NSNull*)request.strUserImage!=[NSNull null] &&[request.strUserImage length]>0)
                {
                    [cell.profileImageView setImageWithURL:[NSURL URLWithString:request.strUserImage] placeholderImage:[UIImage imageNamed:@"img.png"]];
                    
                }
            
                
            }
    cell.acceptButton.tag=indexPath.row;
    [cell.acceptButton addTarget:self action:@selector(m_AcceptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
      return cell;
}
#pragma mark - Method Implementation-
-(IBAction)m_AcceptButtonPressed:(id)sender
{
    if (self.isAirPort==YES)
    {
        PPassengerInfoViewController *passengerInfoVC=[[PPassengerInfoViewController alloc]initWithNibName:@"PPassengerInfoViewController" bundle:nil];
        passengerInfoVC.requestDetail=[requestArray objectAtIndex:[sender tag]];
        [self.navigationController pushViewController:passengerInfoVC animated:YES];
    }
    else
    {
        PPassengerInfoVC *passengerInfoVC=[[PPassengerInfoVC alloc]initWithNibName:@"PPassengerInfoVC" bundle:nil];
        passengerInfoVC.taxiRequestDetail=[requestArray objectAtIndex:[sender tag]];
        [self.navigationController pushViewController:passengerInfoVC animated:YES];
     /*   [SVProgressHUD showWithStatus:@"Accepting..."];
        NSString *string = [NSString stringWithFormat:@"&driverid=%@&requestid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId] ,[[requestArray  valueForKey:@"strRequestId" ] objectAtIndex:[sender tag]]];
        NSLog(@"string is %@", string);
        [[PApiCall sharedInstance]m_GetApiResponse:@"acceptRequest" parameters:string onCompletion:^(NSDictionary *json) {
             [SVProgressHUD showSuccessWithStatus:@"Done"];
             NSLog(@"json is %@",json);
             if ([[json objectForKey:@"result"] isEqualToString:@"success"])
             {
                 PPassengerInfoVC *passengerInfoVC=[[PPassengerInfoVC alloc]initWithNibName:@"PPassengerInfoVC" bundle:nil];
                 passengerInfoVC.taxiRequestDetail=[requestArray objectAtIndex:[sender tag]];
                 [self.navigationController pushViewController:passengerInfoVC animated:YES];
                 
             }
             else if ([[json objectForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
             {
                 
             }
             else
             {
                 [SVProgressHUD showErrorWithStatus:[json objectForKey:@"data"]];
             }
         }];*/
    }
}

#pragma mark - Call Webservice to get airport Request-
-(void)m_CallwebserviceToGetAirportRequest
{
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"getRequest&driverid=" parameters:[[NSUserDefaults standardUserDefaults]valueForKey:userId] onCompletion:^(NSDictionary *json)
     {
        [SVProgressHUD showSuccessWithStatus:@"Done"];
         [requestArray removeAllObjects];
         NSLog(@"%@",json);
         if ([[json objectForKey:@"data"] count]>0&&[json objectForKey:@"error"]==nil)
         {
             for (int i=0; i<[[json objectForKey:@"data"] count]; i++)
             {
                 PAirportRequest *request =[PAirportRequest new];
                 request.strAirportService=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"airport_services"];
                 request.strBasicFee=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"basic_fee"];
                 request.strSourceAddress=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"city_destination"];
                 request.strDepartureDate=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"dept_date"];
                 request.strDestinationAddress=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"drop_location"];
                 request.strFlightNo=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"flight_number"];
                 request.strUserPhone=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"phone_number"];
                 request.strUserSignature=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"signature"];
                 request.strTotalFee=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"total"];
                 request.strUserId=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"userid"];
                 request.strUserImage=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"userimage"];
                 request.strUserName=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"username"];
                 request.strRequestId=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"requestid"];
                  request.strStatus =[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"status"];
                 
                 [requestArray addObject:request];
             }
            
             [self.requestTableView reloadData];
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
-(void)m_CallWebserviceToGetTaxiRequest
{
    [SVProgressHUD showWithStatus:@"Please wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"getTaxiRequest&driverid=" parameters:[[NSUserDefaults standardUserDefaults]valueForKey:userId] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
         [requestArray removeAllObjects];
         NSLog(@"%@",json);
         if ([[json objectForKey:@"data"] count]>0&&[json objectForKey:@"error"]==nil)
         {
             for (int i=0; i<[[json objectForKey:@"data"] count]; i++)
             {
                 PTaxiRequest *request =[PTaxiRequest new];
                
                 request.strSourceAddress=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"sourse_add"];
                request.strDestinationAddress=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"destination_add"];
                
                 request.strUserPhone=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"phone_number"];
                 //request.strUserId=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"userid"];
                 request.strUserImage=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"userimage"];
                 request.strUserName=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"username"];
                 request.strRequestId=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"requestid"];
                 request.strDate=[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"date"];
                 request.strStatus =[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"status"];
                 if([[[[json objectForKey:@"data"]objectAtIndex:i] valueForKey:@"status"] isEqualToString:@"pending"]){
                 [requestArray addObject:request];
                 }
             }
              [self.requestTableView reloadData];
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
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
