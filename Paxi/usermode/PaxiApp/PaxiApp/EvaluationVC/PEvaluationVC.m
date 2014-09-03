//
//  PConfirmationVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 17/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PEvaluationVC.h"

@interface PEvaluationVC ()

@end

@implementation PEvaluationVC
@synthesize sourceAddLabel ,destinationAddLabel ,driverNameLabel ;

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
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self m_FavDetails];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Evaluation";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    self.navigationItem.rightBarButtonItem=homeButton;
}
#pragma mark - Method To get favourite details -
-(void)m_FavDetails
 {
 [SVProgressHUD showWithStatus:@"Please Wait..."];
    
 [[PApiCall sharedInstance]m_GetApiResponse:@"requestDetail" parameters:[NSString stringWithFormat:@"&requestid=1&request_type=taxi"] onCompletion:^(NSDictionary *json)
 {
 [SVProgressHUD showSuccessWithStatus:@"Done"];
     NSDictionary *dic=[json objectForKey:@"data"];
     NSLog(@"%@",json);
 NSLog(@" service detail=%@",dic);
 if ([[json valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"'error"]==nil)
 {
 self.priceLabel .text=[NSString stringWithFormat:@"$%@",[[json valueForKey:@"data"]valueForKey:@"price"]];
 self.sourceAddLabel.text=[[json valueForKey:@"data"]  valueForKey:@"source_address"];
 self.destinationAddLabel.text=[[json valueForKey:@"data"] valueForKey:@"destination_address"];
  self.driverNameLabel.text=[[json valueForKey:@"data"]  valueForKey:@"driver_nmae"];
 }
 else
 {
 [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
 }
 }];
 }
#pragma mark - Method To get favourite details -
-(void)m_FavDone
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];

    NSString *string = [NSString stringWithFormat:@"&requestid=1&userid=%@&source_address=%@&destination_address=%@&driver_name=%@&rating=%d",[[NSUserDefaults standardUserDefaults]valueForKey:userId] ,sourceAddLabel.text,destinationAddLabel.text,driverNameLabel.text,rating];
    [[PApiCall sharedInstance] m_GetApiResponse:@"addToFavourite" parameters:string onCompletion:^(NSDictionary *json) {
        NSDictionary *dic = (NSDictionary *)json;
        NSLog(@"%@", dic);

         if ([[json valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"'error"]==nil)
         {
             [self.navigationController popToRootViewControllerAnimated:YES];   
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"data"]];
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
    [self.navigationController popViewControllerAnimated:NO];
}
-(IBAction)m_statBtnAction:(id)sender{
    
    for(int i =1001 ; i<=[sender tag] ; i++)
    {
         UIImage *btnImage = [UIImage imageNamed:@"star4Selected"];
         [(UIButton *)[self.view viewWithTag:i] setImage:btnImage forState:UIControlStateNormal];
          rating = [sender tag] -1000;
     
  }
    NSLog(@"rating is second %d", rating);
    for(int i =[sender tag]+1 ; i<=1005 ; i++)
    {
        UIImage *btnImage = [UIImage imageNamed:@"star5"];
        [(UIButton *)[self.view viewWithTag:i] setImage:btnImage forState:UIControlStateNormal];
    }
}
-(IBAction)m_doneBtnAction:(id)sender{
       [self m_FavDone];
}
-(IBAction)m_likeBtnAction:(id)sender{
         int i = [sender tag];
          UIImage *img=[(UIButton *) [self.view viewWithTag:i] currentImage];
          
          if(img == [UIImage imageNamed:@"likeSelected"])
          {
              UIImage *btnImage = [UIImage imageNamed:@"like"];
              [(UIButton *)[self.view viewWithTag:i] setImage:btnImage forState:UIControlStateNormal];
          }
          else
          {
           UIImage *btnImage = [UIImage imageNamed:@"likeSelected"];
           [(UIButton *)[self.view viewWithTag:i] setImage:btnImage forState:UIControlStateNormal];
         }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
