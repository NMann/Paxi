//
//  PConfirmationViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 10/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PConfirmationViewController.h"
#import "PSummaryVC.h"
@interface PConfirmationViewController ()

@end

@implementation PConfirmationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - LifeCycle Method-
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self m_AddNavigationBarItem];
    [self.scrollView setContentSize:CGSizeMake(320, 318)];
    
    if (![self.requestDetail.strBasicFee isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strBasicFee!=[NSNull null] &&[self.requestDetail.strBasicFee length]>0)
    {
        self.basicFeeLabel.text=self.requestDetail.strBasicFee;
    }
    if (![self.requestDetail.strAirportService isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strAirportService!=[NSNull null] &&[self.requestDetail.strAirportService length]>0)
    {
        self.airPortServiceLabel.text=self.requestDetail.strAirportService;
    }
    if (![self.requestDetail.strTotalFee isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strTotalFee!=[NSNull null] &&[self.requestDetail.strTotalFee length]>0)
    {
        self.totalFeeLabel.text=self.requestDetail.strTotalFee;
    }
    NSLog(@"%@",self.requestDetail.strSignatureImage);
    if (![self.requestDetail.strUserSignature isKindOfClass:[NSNull class]]&&(NSNull*)self.requestDetail.strUserSignature!=[NSNull null] &&[self.requestDetail.strUserSignature length]>0)
    {
        [self.signatureImageView setImageWithURL:[NSURL URLWithString:self.requestDetail.strUserSignature] placeholderImage:[UIImage imageNamed:@"signature"]];
    }

    // Do any additional setup after loading the view from its nib.
}
#pragma mark - Method To add Navigation Bar Item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Confirmation";
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
- (IBAction)m_ConfirmButtonPressed:(id)sender
{
//    PSummaryVC *summaryVC=[[PSummaryVC alloc]initWithNibName:@"PSummaryVC" bundle:nil];
//    [self.navigationController pushViewController:summaryVC animated:YES];
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"usersToDrivers" parameters:[NSString stringWithFormat:@"&driverid=%@&requestid=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId],self.requestDetail.strRequestId] onCompletion:^(NSDictionary *json)
    {
        [SVProgressHUD showSuccessWithStatus:[json objectForKey:@"data"]];
        [self.navigationController popToRootViewControllerAnimated:YES];
        NSLog(@"%@",json);
    }];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)m_printButtonPressed:(id)sender
{
   // NSString *path = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"png"];
    NSData *dataFromPath = UIImageJPEGRepresentation(self.signatureImageView.image, 1.0);
    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
    if (![UIPrintInteractionController isPrintingAvailable]) {
        [SVProgressHUD showErrorWithStatus:@"Printing is not available on this device."];
    }
  else  if(printController && [UIPrintInteractionController canPrintData:dataFromPath]) {
        
        printController.delegate = self;
        
        UIPrintInfo *printInfo = [UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputPhoto;
        //printInfo.jobName = @"Signature image";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        printController.printInfo = printInfo;
        printController.showsPageRange = YES;
        printController.printingItem = self.signatureImageView.image;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        
        [printController presentAnimated:YES completionHandler:completionHandler];
        
    }
}
-(void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    [SVProgressHUD showErrorWithStatus:@"Prining  canceled."];
}
-(void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController
{
    [SVProgressHUD showSuccessWithStatus:@"Your photo Print Successfully."];
}
@end
