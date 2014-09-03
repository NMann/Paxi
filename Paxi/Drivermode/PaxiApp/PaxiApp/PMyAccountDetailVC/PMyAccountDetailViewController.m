//
//  PMyAccountDetailViewController.m
//  PaxiApp
//
//  Created by Ankush Sharma on 26/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMyAccountDetailViewController.h"

@interface PMyAccountDetailViewController ()

@end

@implementation PMyAccountDetailViewController

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
    [self m_AddNavigationBarItem];
    
      self.Profileimage.layer.cornerRadius=30.0;
    self.imageborderbutton.layer.cornerRadius=30.0;
    self.imageborderbutton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageborderbutton.layer.borderWidth=2.0;
    
     self.scrollview.contentSize =CGSizeMake(320, 504) ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Method To Add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"My Account";
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
@end
