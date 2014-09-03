//
//  PSignUpLoginVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignUpLoginVC.h"
#import "PSignUpNameVC.h"
#import "PLoginViewController.h"
@interface PSignUpLoginVC ()

@end

@implementation PSignUpLoginVC

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
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark -Method Implementation-
- (IBAction)m_SignupButtonPressed:(id)sender
{
    PSignUpNameVC *signupNameVC=[[PSignUpNameVC alloc]initWithNibName:@"PSignUpNameVC" bundle:nil];
    [self.navigationController pushViewController:signupNameVC animated:YES];
}

- (IBAction)m_LoginButtonPressed:(id)sender
{
    NSString *nibName=@"PLoginViewController";
    if (IS_IPHONE5)
        nibName=@"PLoginViewController_5";
    
    PLoginViewController *loginVC=[[PLoginViewController alloc] initWithNibName:nibName bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
