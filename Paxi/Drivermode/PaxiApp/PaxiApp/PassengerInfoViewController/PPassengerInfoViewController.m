//
//  PPassengerInfoViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PPassengerInfoViewController.h"
#import "PConfirmationViewController.h"
@interface PPassengerInfoViewController ()

@end

@implementation PPassengerInfoViewController

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
    
    [self.scrollView setContentSize:CGSizeMake(225, 300)];
    self.profileImage.layer.cornerRadius=30.0;
    self.imageBorderButton.layer.cornerRadius=30.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=2.0;
    
    if (![self.requestDetail.strDepartureDate isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strDepartureDate!=[NSNull null] &&[self.requestDetail.strDepartureDate length]>0)
    {
        self.dateLabel.text=self.requestDetail.strDepartureDate;
    }
    if (![self.requestDetail.strFlightNo isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strFlightNo!=[NSNull null] &&[self.requestDetail.strFlightNo length]>0)
    {
        self.flightNoLabel.text=self.requestDetail.strFlightNo;
    }
    if (![self.requestDetail.strSourceAddress isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strSourceAddress!=[NSNull null] &&[self.requestDetail.strSourceAddress length]>0)
    {
        self.sourceAddressLabel.text=self.requestDetail.strSourceAddress;
    }
    if (![self.requestDetail.strDestinationAddress isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strDestinationAddress!=[NSNull null] &&[self.requestDetail.strDestinationAddress length]>0)
    {
        self.destinationAddressLabel.text=self.requestDetail.strDestinationAddress;
    }
    if (![self.requestDetail.strUserPhone isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strUserPhone!=[NSNull null] &&[self.requestDetail.strUserPhone length]>0)
    {
        self.phoneNoLabel.text=self.requestDetail.strUserPhone;
    }
    if (![self.requestDetail.strUserImage isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strUserImage!=[NSNull null] &&[self.requestDetail.strUserImage length]>0)
    {
        [self.profileImage setImageWithURL:[NSURL URLWithString:self.requestDetail.strUserImage] placeholderImage:[UIImage imageNamed:@"img.png"]];
        
    }
    if (![self.requestDetail.strUserName isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strUserName!=[NSNull null] &&[self.requestDetail.strUserName length]>0)
    {
        self.nameLabel.text=self.requestDetail.strUserName;
    }
      // Do any additional setup after loading the view from its nib.
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
  
    self.navigationItem.title=@"Passenger";
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
- (IBAction)m_NextButtonPressed:(id)sender
{
    PConfirmationViewController *confirmationVC=[[PConfirmationViewController alloc]initWithNibName:@"PConfirmationViewController" bundle:nil];
    confirmationVC.requestDetail=self.requestDetail;
    [self.navigationController pushViewController:confirmationVC animated:NO];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

@end
