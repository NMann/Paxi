//
//  PSignUpNameVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PSignUpNameVC.h"
#import "PSignUpVerificationVC.h"
#import "PSignUpEmailVC.h"
@interface PSignUpNameVC ()

@end

@implementation PSignUpNameVC{
     NSArray *cardTyeArray;
}

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
    [self.view endEditing:YES];
    
//    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    /*add Padding*/
    [[PAppManager sharedData] m_AddPadding:self.nameTextField];
    [[PAppManager sharedData] m_AddPadding:self.mobileTextField];
    [self m_AddRightPadding:self.mobileTextField];
    [self m_AddLeftPadding:self.mobileTextField];
    /* ChangePlaceHolder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.nameTextField];
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:69/255.0 green:178/255.0 blue:181/255.0 alpha:1.0] textField:self.mobileTextField];
    /*Add Swipe Gesture*/
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_SwipeGesture:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    tapGesture.delegate=self;
    [self.view addGestureRecognizer:tapGesture];
    [self m_AddNavigationBarItem];
  
    cardTyeArray=[[NSArray alloc]initWithObjects:@"China",@"Canada",@"US", nil];
   self.m_codeLabel.text = @"+86";
    type=@"China";
  
}

-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Sign Up";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    backButton.tintColor=[UIColor whiteColor];
    self.navigationItem.leftBarButtonItem=backButton;
}
#pragma mark - Method Implementation-
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - Sign Up Button Pressed-
- (IBAction)m_SignupButtonPressed:(id)sender
{
    
}
#pragma mark- Swipe Gesture Implementation-
-(void)m_SwipeGesture:(UISwipeGestureRecognizer*)sender
{
    if ([sender state]==UIGestureRecognizerStateRecognized)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - Tap Gesture Implementation-
-(void)m_TapGesture:(UITapGestureRecognizer*)sender
{
    [self.view endEditing:YES];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)m_AddRightPadding:(UITextField*)sender
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    sender.rightView=paddingView;
    sender.rightViewMode=UITextFieldViewModeAlways;
}
-(void)m_AddLeftPadding:(UITextField*)sender
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 20)];
    sender.leftView=paddingView;
    sender.leftViewMode=UITextFieldViewModeAlways;
}

#pragma mark -Validate Email-
-(BOOL) NSStringIsValidPhone:(NSString *)checkString
{
    NSCharacterSet *charcter =[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    NSString *filtered;
    filtered = [[checkString componentsSeparatedByCharactersInSet:charcter] componentsJoinedByString:@""];
    return [checkString isEqualToString:filtered];
}
#pragma mark - Method Implementation-
- (IBAction)m_NextButtonPressed:(id)sender
{
//    PSignUpVerificationVC *verificationVC=[[PSignUpVerificationVC alloc]initWithNibName:@"PSignUpVerificationVC" bundle:nil];
//    [self.navigationController pushViewController:verificationVC animated:YES];
   
    
if ([self.nameTextField.text length]>0 && [self.mobileTextField.text length]>0 )
{
    if ((([self NSStringIsValidPhone:self.mobileTextField.text] )&& ([ type isEqualToString :@"China" ]&& [self.mobileTextField.text length] == 11)) || ([type isEqualToString :@"US" ]&& [self.mobileTextField.text length] == 10)){
       
        NSString *dataString =[NSString stringWithFormat:@"%@%@",self.m_codeLabel.text, self.mobileTextField.text];
     
        [SVProgressHUD showWithStatus:@"Please Wait...."];
        NSString *string = [NSString stringWithFormat:@"&username=%@&phone=%@",self.nameTextField.text,dataString];

        [[PApiCall sharedInstance] m_GetApiResponse:@"register" parameters:string onCompletion:^(NSDictionary *json) {
            NSDictionary *dic = (NSDictionary *)json;
            NSLog(@"%@", dic);
            if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
            {
                [SVProgressHUD showSuccessWithStatus:@"Done"];
                [[NSUserDefaults standardUserDefaults]setValue:[[dic objectForKey:@"data"]valueForKey: @"userid"] forKey:@"userid"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                PSignUpEmailVC *emailVC=[[PSignUpEmailVC alloc]initWithNibName:@"PSignUpEmailVC" bundle:nil];
                [self.navigationController pushViewController:emailVC animated:YES];
              
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
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter Correct Mobile Number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    }
   else
   {
       UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Please Enter The Required Information." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
       [alert show];
   }
   
}

- (IBAction)m_flagbuttonPressed:(id)sender {
    if (self.m_flagtableview.hidden==YES)
    {
        self.m_flagtableview.hidden=NO;
    }else{
        self.m_flagtableview.hidden=YES;
    }
    
}
#pragma mark - TextField Delegate-
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    [self.scrollView setContentOffset:CGPointMake(0,120) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  /*  if(textField.tag == 1 )
    {
   
    }*/
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 120)];
        [nextResponder becomeFirstResponder];
    }
    else
    {
        // Not found, so remove keyboard.
        [self.scrollView setContentOffset:CGPointMake(0,0)];
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
//    if (textField==self.mobileTextField)
//    {
//        NSUInteger newLength = [self.mobileTextField.text length] + [string length] - range.length;
//        return (newLength > 14) ? NO : YES;
//    }
//    else
     return YES;
}
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [cardTyeArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 29.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.m_flagButton setImage:[UIImage imageNamed:[cardTyeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];

    [self.m_flagtableview setHidden:YES];
    if(indexPath.row==0){
        self.m_codeLabel.text = @"+86";
        type=@"China";
    }
    else{
        self.m_codeLabel.text = @"+1";
        type =@"US";
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"Cell";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==Nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
        
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIImageView * cardimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, 8, 23, 17)];
    [  cardimage setImage:[UIImage imageNamed:[cardTyeArray objectAtIndex:indexPath.row]]];
     cardimage.userInteractionEnabled=YES;
    [cell.contentView addSubview:cardimage];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 8, 50, 17)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0]];
    titleLabel.textColor=[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0];
    titleLabel.text=[cardTyeArray objectAtIndex:indexPath.row];
    titleLabel.userInteractionEnabled=YES;
    [cell.contentView addSubview:titleLabel];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UITableView *tableView=self.m_flagtableview;
    CGPoint touchPoint=[touch locationInView:tableView];
    return ![tableView hitTest:touchPoint withEvent:nil];
}
#pragma mark - Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
