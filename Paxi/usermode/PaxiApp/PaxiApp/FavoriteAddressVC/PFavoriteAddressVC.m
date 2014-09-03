//
//  PFavoriteAddressVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PFavoriteAddressVC.h"
#import "PFavoriteAddressCell.h"
@interface PFavoriteAddressVC ()

@end

@implementation PFavoriteAddressVC

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
    favaddressArray = [[NSMutableArray alloc]init];
    favAdd=[[NSUserDefaults standardUserDefaults]objectForKey:@"FAVADD"];
    [self m_FavAddress];
 
}
#pragma mark -Method To get favourite Address-
-(void)m_FavAddress
{
    
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"getFavoriteAddress" parameters:[NSString stringWithFormat:@"&userid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId]] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
        if ([[json objectForKey:@"data"] count]>0&&[json objectForKey:@"error"]==nil)
         {
             for(int i=0 ; i<[[json objectForKey:@"data"] count ] ;i++){
                    [favaddressArray  addObject:[[json objectForKey:@"data"] objectAtIndex:i]];
             }
                   NSLog(@" fav are%@",favaddressArray);
             [self.m_AddressTableview reloadData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         }
     }];
}
#pragma mark -Method To Add Navigation Bar Item-
    -(void)m_AddNavigationBarItem
    {
        [self.navigationItem setHidesBackButton:YES];
        
        self.navigationItem.title=@"Favorite Addresses";
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
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pickupAction:(id)sender{
    
    NSString *dropofflocation = [favaddressArray objectAtIndex:[sender tag]];

    [self.delegate addquestions:dropofflocation];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dropoffAction:(id)sender{
    NSString *pickuplocation = [favaddressArray objectAtIndex:[sender tag]];
    
    [self.delegate addquestions:pickuplocation];
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView Delegate-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return favaddressArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"Cell";
    PFavoriteAddressCell *cell=(PFavoriteAddressCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PFavoriteAddressCell" owner:self options:nil];
        
        cell=[nib objectAtIndex:0];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.locationlabel.text = [favaddressArray objectAtIndex:indexPath.row];
    
    cell.pickupBtn.tag = indexPath.row;
    cell.dropoffBtn.tag = indexPath.row;

    if ([favAdd isEqualToString:@"pickup"]){
        [cell.dropoffBtn setHidden:YES] ;
        [cell.pickupBtn addTarget:self action:@selector(pickupAction:) forControlEvents:UIControlEventTouchUpInside];

    }else  if ([favAdd isEqualToString:@"dropoff"]){
        [cell.pickupBtn setHidden:YES];
        [cell.dropoffBtn addTarget:self action:@selector(dropoffAction:) forControlEvents:UIControlEventTouchUpInside];

        
    }else if ([favAdd isEqualToString:@"favadd"]){
          [cell.pickupBtn setHidden:NO];
         [cell.dropoffBtn setHidden:NO] ;
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
     [cell setBackgroundColor:[UIColor clearColor]];
    if (indexPath.row %2==0)
    {
        [cell setBackgroundColor:[UIColor colorWithRed:33/255.0 green:61/255.0 blue:89/255.0 alpha:1.0]];
    }
   else
   {
       [cell setBackgroundColor:[UIColor colorWithRed:33/255.0 green:61/255.0 blue:89/255.0 alpha:0.4]];

   }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
