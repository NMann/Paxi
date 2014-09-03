//
//  PCarTypeVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PCarTypeVC.h"
#import "PMoreCarVC.h"
#import "PAirportConfirmationVC.h"
#import "PCarCustomCell.h"
@interface PCarTypeVC ()
{
    NSMutableArray *carDetailArray;
    NSMutableDictionary *carDetailDictionary;
}
@end

@implementation PCarTypeVC

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
    [self m_GetCarDetails];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize=CGSizeMake(320, 220);
    carDetailArray=[[NSMutableArray alloc]init];
    carDetailDictionary=[[NSMutableDictionary alloc]init];
    // Do any additional setup after loading the view from its nib.
    [self m_AddNavigationBarItem];
    
    //collectionView
    UICollectionViewFlowLayout *layout= [[UICollectionViewFlowLayout alloc]init];
    [self.CarCollectionView setCollectionViewLayout:layout];
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(10,20,0,20);
     [self.CarCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"test"];
  //  [self.CarCollectionView registerClass:[PCarCustomCell class] forCellWithReuseIdentifier:@"test"];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Car Type";
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
- (IBAction)m_MoreButtonPressed:(id)sender
{
    PMoreCarVC *moreCarVC=[[PMoreCarVC alloc]initWithNibName:@"PMoreCarVC" bundle:nil];
    moreCarVC.carTypeArray=carDetailArray;
    moreCarVC.strDepartureDate=self.strDepartureDate;
    moreCarVC.strDestination=self.strDestination;
    moreCarVC.strDropOffLocation=self.strDropOffLocation;
    moreCarVC.strFlightNo=self.strFlightNo;
    moreCarVC.strPassengerName=self.strPassengerName;
    [self.navigationController pushViewController:moreCarVC animated:YES];
}

- (IBAction)m_ConfirmationButtonPressed:(id)sender
{
    
    [SVProgressHUD showWithStatus:@"Please Wait...."];
    
    
    NSString *string = [NSString stringWithFormat:@"&userid=%@&flight_number=%@&dept_date=%@&city_destination=%@&passenger_name=%@&drop_location=%@&car_type=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId],self.strFlightNo,self.strDepartureDate,self.strDestination,self.strPassengerName,self.strDropOffLocation,self.strCarId];
    
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

- (IBAction)m_carSelected:(id)sender
{
    [self.name1Label setText:[[carDetailArray objectAtIndex:[sender tag]-1] valueForKey:@"carName"]];
    [self.passenger1Label setText:[[carDetailArray objectAtIndex:[sender tag]-1] valueForKey:@"passengerSeats"]];
    [self.luggage1Label setText:[[carDetailArray objectAtIndex:[sender tag]-1] valueForKey:@"luggages"]];
    self.strCarId=[[carDetailArray objectAtIndex:[sender tag]-1] valueForKey:@"carId"];
    [self.selectedCarImage setImage:[sender currentImage]];
}
#pragma mark- Method To Get Car Details-
-(void)m_GetCarDetails
{
    [SVProgressHUD showWithStatus:@"Please Wait...."];
    
    
    NSString *string = [NSString stringWithFormat:@"%@getCars", BaseURLString];
    
    
    
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        
        NSDictionary *dic = (NSDictionary *)responseObject;
        
        NSLog(@"%@", dic);
        if ([[dic valueForKey:@"return"] integerValue]==1)
        {
            [carDetailArray removeAllObjects];
            [SVProgressHUD showSuccessWithStatus:@"Done"];
           for (int i=0; i<[[dic objectForKey:@"data"] count]; i++)
            {
                [carDetailDictionary setObject:[[[dic objectForKey:@"data"]valueForKey: @"car_name"] objectAtIndex:i] forKey:@"carName"];
                [carDetailDictionary setObject:[[[dic objectForKey:@"data"] valueForKey:@"luggages"] objectAtIndex:i] forKey:@"luggages"];
                [carDetailDictionary setObject:[[[dic objectForKey:@"data"]valueForKey: @"passenger_seats"] objectAtIndex:i] forKey:@"passengerSeats"];
                [carDetailDictionary setObject:[[[dic objectForKey:@"data"] valueForKey:@"carid"] objectAtIndex:i] forKey:@"carId"];
                [carDetailArray addObject:[carDetailDictionary mutableCopy]];
               
            }
            
        //    [carDetailArray addObject:[dic objectForKey:@"data"]];
             [self m_UpdateInfo];
            self.CarCollectionView.delegate=self;
            self.CarCollectionView.dataSource=self;
            [self.CarCollectionView reloadData];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:[dic valueForKey:@"data"]];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
    
    [[NSOperationQueue currentQueue] addOperation:operation];

}
-(void)m_UpdateInfo
{
    [self.name1Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"carName"]];
    [self.passenger1Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"passengerSeats"]];
    [self.luggage1Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"luggages"]];
    self.strCarId=[[carDetailArray objectAtIndex:0 ]valueForKey:@"carId"];
    [self.selectedCarImage setImage:[UIImage imageNamed:@"1white-car.png"]];
 /*   [self.name2Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"carName"]];
    [self.passenger2Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"passengerSeats"]];
    [self.luggage2Label setText:[[carDetailArray objectAtIndex:0] valueForKey:@"luggages"]];
    
    [self.name3Label setText:[[carDetailArray objectAtIndex:1] valueForKey:@"carName"]];
    [self.passenger3Label setText:[[carDetailArray objectAtIndex:1] valueForKey:@"passengerSeats"]];
    [self.luggage3Label setText:[[carDetailArray objectAtIndex:1] valueForKey:@"luggages"]];
    
    [self.name4Label setText:[[carDetailArray objectAtIndex:2] valueForKey:@"carName"]];
    [self.passenger4Label setText:[[carDetailArray objectAtIndex:2] valueForKey:@"passengerSeats"]];
    [self.luggage4Label setText:[[carDetailArray objectAtIndex:2] valueForKey:@"luggages"]];*/
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - collection view data source
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [carDetailArray count]>3?4:[carDetailArray count]+1;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path{
    
    return 0;
}

- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
      UICollectionViewCell *cell = (UICollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"test" forIndexPath:indexPath];
    for (UIImageView *imageView  in cell.contentView.subviews) {
        if ([imageView isKindOfClass:[UIImageView class]])
        {
            [imageView removeFromSuperview ];
        }
    }
  for (UILabel *label  in cell.contentView.subviews) {
        if ([label isKindOfClass:[UILabel class]])
        {
            [label removeFromSuperview ];
        }
    }
    for (UIButton *button  in cell.contentView.subviews) {
        if ([button isKindOfClass:[UIButton class]])
        {
            [button removeFromSuperview ];
        }
    }
   
    if (indexPath.row <3 && indexPath.row!=3  ) {
        UIImageView * CarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29,10,72,32)];
       CarImageView.image=[UIImage imageNamed:@"1white-car.png"];
        CarImageView.contentMode=UIViewContentModeScaleAspectFit;
        [cell.contentView addSubview:CarImageView];
        
        UILabel  *CarInfolabel = [[UILabel alloc] init];
        [CarInfolabel setFrame:CGRectMake(5,40,120,70)];
        CarInfolabel.textAlignment=NSTextAlignmentCenter;
        CarInfolabel.numberOfLines=3;
        CarInfolabel.font=[UIFont fontWithName:@"Helvetica Neue " size:14.0];
        CarInfolabel.textColor=[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0];
        CarInfolabel.text=[NSString stringWithFormat:@"%@\n%@\n%@",[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"carName"],[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"passengerSeats"],[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"luggages"]];
        [cell.contentView addSubview:CarInfolabel];
    }
    else if(indexPath.row==3)
    {
        UIImageView * CarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29,10,72,32)];
       CarImageView.image=[UIImage imageNamed:@"MoreCar"];
        CarImageView.contentMode =UIViewContentModeScaleAspectFit ;
        [cell.contentView addSubview:CarImageView];
      
        UIButton *moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [moreButton setImage:[UIImage  imageNamed:@"more.png"] forState:UIControlStateNormal];
       // [moreButton setTitle:@"More" forState:UIControlStateNormal];
       // moreButton.imageEdgeInsets=UIEdgeInsetsMake(0, 22, 0, 0);
      //  moreButton.titleEdgeInsets=UIEdgeInsetsMake(0, 0, 0,20);
        [moreButton setFrame:CGRectMake(29, 40, 75, 30)];
        [cell.contentView addSubview:moreButton];
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
     cell.backgroundColor = [UIColor colorWithRed:18/255.0 green:43/255.0 blue:68/255.0 alpha:0.6];
       if (indexPath.row <3  ) {
           [self.name1Label setText:[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"carName"]];
            [self.passenger1Label setText:[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"passengerSeats"]];
          [self.luggage1Label setText:[[carDetailArray objectAtIndex:indexPath.row] valueForKey:@"luggages"]];
         self.strCarId=[[carDetailArray objectAtIndex:indexPath.row ]valueForKey:@"carId"];
          [self.selectedCarImage setImage:[UIImage imageNamed:@"1white-car.png"]];
     
       }else{
           PMoreCarVC *moreCarVC=[[PMoreCarVC alloc]initWithNibName:@"PMoreCarVC" bundle:nil];
           moreCarVC.carTypeArray=carDetailArray;
           moreCarVC.strDepartureDate=self.strDepartureDate;
           moreCarVC.strDestination=self.strDestination;
           moreCarVC.strDropOffLocation=self.strDropOffLocation;
           moreCarVC.strFlightNo=self.strFlightNo;
           moreCarVC.strPassengerName=self.strPassengerName;
           [self.navigationController pushViewController:moreCarVC animated:YES];
       }
}
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell* cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(130, 130);
}

@end
