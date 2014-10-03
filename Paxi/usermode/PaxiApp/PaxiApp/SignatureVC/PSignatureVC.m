//
//  PSignatureVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignatureVC.h"
#import "SmoothLineView.h"
#import <CoreMotion/CoreMotion.h>
@interface PSignatureVC ()
@property (nonatomic) SmoothLineView * canvas;

@end

@implementation PSignatureVC

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
    
    self.canvas = self.drawingView;
    // Do any additional setup after loading the view from its nib.
    [self m_AddNavigationBarItem];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Signature";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
  UIBarButtonItem *leftBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Clear" style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];

    self.navigationItem.leftBarButtonItem=leftBarButton;
    
    UIBarButtonItem *RightBarButton=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(m_DoneButtonPressed:)];

    self.navigationItem.rightBarButtonItem=RightBarButton;

    
//    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
//    self.navigationItem.leftBarButtonItem=backButton;
//    
//    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
//    self.navigationItem.rightBarButtonItem=homeButton;
}
#pragma mark - Method Implementation-
-(IBAction)m_HomeButtonPressed:(id)sender
{
   
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)m_DoneButtonPressed:(id)sender
{
    UIGraphicsBeginImageContext(self.drawingView.bounds.size);
    [self.drawingView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    NSData *ImageData=UIImagePNGRepresentation(image);
    UIImage *Finalimage=[UIImage imageWithData:ImageData scale:1.0];
    UIGraphicsEndImageContext();
    [self.delegate SignatureImage:Finalimage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    //[self dismissViewControllerAnimated:NO completion:nil];
 [self.canvas clear];
}
-(BOOL)canBecomeFirstResponder {
    return YES;
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [self.canvas clear];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
