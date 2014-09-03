//
//  PMoreCarVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMoreCarVC.h"
#import "PAirportConfirmationVC.h"
@interface PMoreCarVC ()

@end

@implementation PMoreCarVC

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
    // Do any additional setup after loading the view from its nib.
    [self m_AddNavigationBarItem];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"More Types";
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
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.carTypeArray count]-3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self m_Confirmation:[[self.carTypeArray objectAtIndex:indexPath.row+3 ] valueForKey:@"carId"]];
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
    
    
    UILabel *carNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 14, 300, 21)];
    carNameLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:17.0];
    carNameLabel.text=[[self.carTypeArray objectAtIndex:indexPath.row+3 ] valueForKey:@"carName"];
    carNameLabel.textColor=[UIColor whiteColor];
    [cell.contentView addSubview:carNameLabel];
    
    UILabel *carInfoLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 35, 300, 21)];
    carInfoLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:17.0];
    carInfoLabel.text=[NSString stringWithFormat:@"%@,%@",[[self.carTypeArray objectAtIndex:indexPath.row+3 ] valueForKey:@"passengerSeats"],[[self.carTypeArray objectAtIndex:indexPath.row+3 ] valueForKey:@"luggages"]];
    carInfoLabel.textColor=[UIColor colorWithRed:60/255.0 green:157/255.0 blue:172/255.0 alpha:1.0];
    [cell.contentView addSubview:carInfoLabel];
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
#pragma mark - Confirmation Method-
- (void)m_Confirmation:(NSString *)carId
{
    
    [SVProgressHUD showWithStatus:@"Please Wait...."];
    NSString *string = [NSString stringWithFormat:@"&userid=%@&flight_number=%@&dept_date=%@&city_destination=%@&passenger_name=%@&drop_location=%@&car_type=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId],self.strFlightNo,self.strDepartureDate,self.strDestination,self.strPassengerName,self.strDropOffLocation,carId];
    
    [[PApiCall sharedInstance]m_GetApiResponse:@"travel" parameters:string onCompletion:^(NSDictionary *json) {
        NSDictionary *dic = (NSDictionary *)json;
        
        NSLog(@"%@", dic);
        if ([[dic valueForKey:@"return"] integerValue]==1&&[json objectForKey:@"error"]==nil)
        {
            [SVProgressHUD showSuccessWithStatus:@"Done"];
            NSString *sourceAddress;
            
            if ([[[dic valueForKey:@"data"] valueForKey:@"date"] length]>0 && ![[[dic valueForKey:@"data"] valueForKey:@"date"]isKindOfClass:[NSNull class]] && (NSNull*)[[dic valueForKey:@"data"] valueForKey:@"date"]!=[NSNull null] )
            {
                
                sourceAddress=[[dic valueForKey:@"data"] valueForKey:@"date"];
            }
            if ([[[dic valueForKey:@"data"] valueForKey:@"flightno"] length]>0 && ![[[dic valueForKey:@"data"] valueForKey:@"flightno"]isKindOfClass:[NSNull class]] && (NSNull*)[[dic valueForKey:@"data"] valueForKey:@"flightno"]!=[NSNull null] )
            {
                if ([sourceAddress length]>0)
                {
                    sourceAddress=[NSString stringWithFormat:@"%@\n%@",sourceAddress,[[dic valueForKey:@"data"] valueForKey:@"flightno"]];
                    
                }
                else
                    sourceAddress=[[dic valueForKey:@"data"] valueForKey:@"flightno"];
            }
            if ([[[dic valueForKey:@"data"] valueForKey:@"sourseAddress"] length]>0 && ![[[dic valueForKey:@"data"] valueForKey:@"sourseAddress"]isKindOfClass:[NSNull class]] && (NSNull*)[[dic valueForKey:@"data"] valueForKey:@"sourseAddress"]!=[NSNull null])
            {
                if ([sourceAddress length]>0)
                {
                    sourceAddress=[NSString stringWithFormat:@"%@\n%@",sourceAddress,[[dic valueForKey:@"data"] valueForKey:@"date"]];
                    
                }
                else
                    sourceAddress=[[dic valueForKey:@"data"] valueForKey:@"sourseAddress"];
            }
            PAirportConfirmationVC *airportConfirmationVC=[[PAirportConfirmationVC alloc]initWithNibName:@"PAirportConfirmationVC" bundle:nil];
            airportConfirmationVC.strSourceAddress=sourceAddress;
            airportConfirmationVC.strDestinationAddress=[[dic valueForKey:@"data"] valueForKey:@"destinationAddress"];
            airportConfirmationVC.strBasicFee=[[dic valueForKey:@"data"] valueForKey:@"basic_fee"];
            airportConfirmationVC.strAirportCharges=[[dic valueForKey:@"data"] valueForKey:@"airport_service"];
            airportConfirmationVC.strTotalFee=[[dic valueForKey:@"data"] valueForKey:@"total"];
            airportConfirmationVC.strId=[[dic valueForKey:@"data"] valueForKey:@"id"];

            [self.navigationController pushViewController:airportConfirmationVC animated:YES];
            
        }
        else if ([[dic valueForKey:@"return"] integerValue]==0)
        {
            [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"data"]];
            
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
