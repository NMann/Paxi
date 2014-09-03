//
//  PMyProfileVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMyProfileVC.h"

@interface PMyProfileVC ()
{
    UIActionSheet *actionSheet;
    UIImagePickerController *imagePicker;
}

@end

@implementation PMyProfileVC

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
    
    [self.scrollView setContentSize:CGSizeMake(0, 333)];
    self.profileImage.layer.cornerRadius=30.0;
    self.imageBorderButton.layer.cornerRadius=30.0;
    self.imageBorderButton.layer.borderColor=[UIColor whiteColor].CGColor;
    self.imageBorderButton.layer.borderWidth=2.0;
    
    actionSheet=[[UIActionSheet alloc]initWithTitle:@"Choose" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture",@"Choose From Library", nil];
    
    imagePicker=[[UIImagePickerController alloc]init];
    imagePicker.delegate=self;
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    [self m_AddNavigationBarItem];
    [self m_GetProfileInfo];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -Method To Add Navigation Bar Item
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"My Profile";
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
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    if ([sender state]==UIGestureRecognizerStateRecognized)
    {
        [self.view endEditing:YES];
        self.nameTextField.userInteractionEnabled=NO;
        self.emailTextField.userInteractionEnabled=NO;
        self.mobileNumberTextField.userInteractionEnabled=NO;
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
}
-(IBAction)m_HomeButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)m_MyAccountButtonPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    NSData *imageData=UIImageJPEGRepresentation(self.profileImage.image , 1.0);
    NSString *imageurl=[[PApiCall sharedInstance]uploadimage:imageData];
    if ([imageurl length]>0)
    {
        NSString *requestBody=[NSString stringWithFormat:@"&userid=%@&image=%@&mode=driver&email=%@&phone=%@&name=%@",[[NSUserDefaults standardUserDefaults]valueForKey:userId],imageurl,self.emailTextField.text,self.mobileNumberTextField.text,self.nameTextField.text];
        [[PApiCall sharedInstance]m_GetApiResponse:@"editProfile" parameters:requestBody onCompletion:^(NSDictionary *json)
         {
             NSDictionary *dic=json;
             NSLog(@"%@",dic);
             if ([[dic valueForKey:@"return"]integerValue ]==1)
             {
                 [SVProgressHUD showSuccessWithStatus:[dic valueForKey:@"data"]];
             }
         }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"Try Again"];
    }

}
- (IBAction)m_ImageButtonPressed:(id)sender
{
    [actionSheet showInView:self.view];
}
- (IBAction)editButtonPressed:(id)sender
{
    if ([sender tag]==1)
    {
        self.nameTextField.userInteractionEnabled=YES;
        [self.nameTextField becomeFirstResponder];
    }
    else if ([sender tag]==2)
    {
        self.emailTextField.userInteractionEnabled=YES;
        [self.emailTextField becomeFirstResponder];
        [self.scrollView setContentOffset:CGPointMake(0, 70) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
        self.mobileNumberTextField.userInteractionEnabled=YES;
        [self.mobileNumberTextField becomeFirstResponder];
    }
}
#pragma mark - UiTextField delegate-
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
  
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.nameTextField.userInteractionEnabled=NO;
    self.emailTextField.userInteractionEnabled=NO;
    self.mobileNumberTextField.userInteractionEnabled=NO;
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self.scrollView setUserInteractionEnabled:YES];
    return YES;
}
#pragma mark - Action sheet Delegate-
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"Camera is not available."];
        }
    }
    else if (buttonIndex==1)
    {
        imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
#pragma mark - Image Picker Controller Delegate-
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.profileImage.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark- Method To get Profile Info-
-(void)m_GetProfileInfo
{
    [SVProgressHUD showWithStatus:@"Please Wait..."];
    [[PApiCall sharedInstance]m_GetApiResponse:@"showProfile" parameters:[NSString stringWithFormat:@"&userid=%@&mode=driver",[[NSUserDefaults standardUserDefaults]valueForKey:userId]] onCompletion:^(NSDictionary *json)
     {
         [SVProgressHUD showSuccessWithStatus:@"Done"];
         NSDictionary *dic=json;
         NSLog(@"%@",dic);
         if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
         {
             self.nameTextField.text=[[dic valueForKey:@"data"] valueForKey:@"username"];
             self.mobileNumberTextField.text=[[dic valueForKey:@"data"] valueForKey:@"mobile"];
             self.emailTextField.text=[[dic valueForKey:@"data"] valueForKey:@"email"];
             if ([[[dic valueForKey:@"data"] valueForKey:@"userimage"] length])
             {
                 self.profileImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[dic valueForKey:@"data"] valueForKey:@"userimage"]]]];
             }
         }
         else
         {
             [SVProgressHUD showErrorWithStatus:[json objectForKey:@"error"]];
         }
     }];
}
#pragma mark - LifeCycle Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
