//
//  PFavoriteDriverVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PFavoriteDriverVC.h"
#import "PFavoriteDriverCell.h"
@interface PFavoriteDriverVC ()

@end

@implementation PFavoriteDriverVC
@synthesize collectionView;

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
    UINib *cellNib = [UINib nibWithNibName:@"PFavoriteDriverCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    // Do any additional setup after loading the view from its nib.
    [self m_AddNavigationBarItem];
    [self m_FavDriver];

}
#pragma mark -Method To Add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Favorite Drivers";
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
#pragma mark- Method To favourite Driver-
-(void)m_FavDriver
{

    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"getFavoriteDrivers" parameters:[NSString stringWithFormat:@"&userid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId]] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
         NSLog(@"%@",json);
         favDriverDict=(NSDictionary*)json;
         NSLog(@"%@",favDriverDict);
         
         if ([[json objectForKey:@"data"] count]>0&&[json objectForKey:@"error"]==nil)
         {
             [self.collectionView reloadData];
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         }
     }];
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
#pragma mark - UICollectionView Delegate And DataSource Method -
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [[favDriverDict valueForKey:@"data"] count];
}
// 2
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}
// 3
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cvCell";
    
    PFavoriteDriverCell *cell = (PFavoriteDriverCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor=[UIColor clearColor];
   NSString *msg=[NSString stringWithFormat:@"%@\n%@",[[[favDriverDict objectForKey:@"data"]objectAtIndex:indexPath.row] objectForKey:@"username"] , [[[favDriverDict objectForKey:@"data"]objectAtIndex:indexPath.row] objectForKey:@"phone"]];
    if ([[[[favDriverDict objectForKey:@"data"]objectAtIndex:indexPath.row] objectForKey:@"profile_Image"]length])
    {
       cell.profileimage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[[favDriverDict objectForKey:@"data"]objectAtIndex:indexPath.row] objectForKey:@"profile_Image"]]]];
    }
    
    [cell.driverinfoLbl  setText :msg];
    
    return cell;
    
}- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
