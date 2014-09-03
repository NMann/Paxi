//
//  PCardInfoVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 15/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PCardInfoVC.h"
#import "PLoginViewController.h"
#import "CreditCardValidation.h"
@interface PCardInfoVC ()
{
    NSArray *cardTyeArray;
    NSMutableArray *monthArray,*yearArray;
    NSDateFormatter *dateformat,*format;
}
@end

@implementation PCardInfoVC

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
    [self.view endEditing:YES];
    //    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ispickerShow=NO;
    monthArray=[[NSMutableArray alloc] initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December", nil];
  

    //Get Current Year into
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    int currentyear  = [[formatter stringFromDate:[NSDate date]] intValue];
    
    yearArray=[[NSMutableArray alloc]init];
    for (int i=currentyear+1; i<3000; i++)
    {
        [yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM/yyyy"];
    dateformat=[[NSDateFormatter alloc]init];
    [dateformat setDateFormat:@"MM/yyyy"];
    /*Add Swipe Gesture*/
    UISwipeGestureRecognizer *swipeGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(m_SwipeGesture:)];
    swipeGesture.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGesture];
    /*Add Tap Gesture in Scrollview*/
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(m_TapGesture:)];
    tapGesture.delegate=self;
    [self.scrollView addGestureRecognizer:tapGesture];
    [self.view bringSubviewToFront:self.cardTypeTableView];
    /* Initialize CardType Array*/
    cardTyeArray=[[NSArray alloc]initWithObjects:@"Master Card",@"American Express",@"Visa",@"Discover Network",@"Union Pay", nil];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - Method Implementation-
- (IBAction)m_CardTypeButtonPressed:(id)sender
{
    if (self.cardTypeTableView.hidden==YES)
    {
        self.cardTypeTableView.hidden=NO;
        [self.view endEditing:YES];
    }
}




- (IBAction)m_DateButtonPressed:(id)sender
{
    if (ispickerShow==NO)
    {
        [self.view endEditing:YES];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect dateViewFrame=self.pickerView.frame;
            dateViewFrame.origin.y=dateViewFrame.origin.y-dateViewFrame.size.height;
            self.pickerView.frame=dateViewFrame;
            ispickerShow=YES;
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

- (IBAction)m_DoneButtonPressed:(id)sender
{
  
    NSString *name=[[NSUserDefaults standardUserDefaults]valueForKey:@"name"];
    NSString *email=[[NSUserDefaults standardUserDefaults]valueForKey:@"emailId"];
    NSString *password=[[NSUserDefaults standardUserDefaults]valueForKey:@"password"];
    NSString *mobile=[[NSUserDefaults standardUserDefaults]valueForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"name"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"emailId"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"password"];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (self.accountNoTextField.text.length>0 &&self.nameTextField.text.length>0&&self.cvcTextField.text.length>0 && [self.dateButton currentTitle].length>0)
    {
        BOOL isValid = [self checkCreditCardValidity] ;
        NSLog(@"isValid: %d",isValid) ;
        if(isValid == 0) return ;
        // 1
        [SVProgressHUD showWithStatus:@"Please Wait...."];
        
       
        NSString *string = [NSString stringWithFormat:@"&username=%@&email=%@&phone=%@&password=%@&card_type=%@&account_number=%@&credit_card_name=%@&exp_date=%@&cvc=%@&user_mode=user",name,email,mobile,password,self.cardType,self.accountNoTextField.text,self.nameTextField.text,[self.dateButton currentTitle],self.cvcTextField.text];
        [[PApiCall sharedInstance]m_GetApiResponse:@"register" parameters:string onCompletion:^(NSDictionary *json) {
            NSDictionary *dic = (NSDictionary *)json;
            
            NSLog(@"%@", dic);
            if ([[dic valueForKey:@"return"] integerValue]==1 &&[json objectForKey:@"error"]==nil)
            {
                [SVProgressHUD showSuccessWithStatus:@"Done"];
                NSString *nibName=@"PLoginViewController";
                if (IS_IPHONE5)
                    nibName=@"PLoginViewController_5";
                
                PLoginViewController *loginVC=[[PLoginViewController alloc] initWithNibName:nibName bundle:nil];
                [self.navigationController pushViewController:loginVC animated:YES];
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
       [SVProgressHUD showErrorWithStatus:@"Please enter the required information."];
   }
}

- (IBAction)m_DateSelected:(id)sender
{
//    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
//    [dateformat setDateFormat:@"MM/yyyy"];
    self.date=[dateformat stringFromDate:[sender date]];
    [self.dateButton setTitle:self.date forState:UIControlStateNormal];
}

- (IBAction)m_CancelButtonPressed:(id)sender
{
    [UIView animateWithDuration:0.3 animations:^{
        ispickerShow=NO;
        CGRect dateViewFrame=self.pickerView.frame;
        dateViewFrame.origin.y=dateViewFrame.origin.y+dateViewFrame.size.height;
        self.pickerView.frame=dateViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)m_Done:(id)sender
{
    self.date=[NSString stringWithFormat:@"%@/%@",[monthArray objectAtIndex:[self.datePicker selectedRowInComponent:0]],[yearArray objectAtIndex:[self.datePicker selectedRowInComponent:1]]];
    NSDate *date=[format dateFromString:self.date];
    self.date=[dateformat stringFromDate:date];
    [self.dateButton setTitle:self.date forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
         ispickerShow=NO;
        CGRect dateViewFrame=self.pickerView.frame;
        dateViewFrame.origin.y=dateViewFrame.origin.y+dateViewFrame.size.height;
        self.pickerView.frame=dateViewFrame;
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)m_validateCard:(id)sender
{
    NSString *cc_num_string = ((UITextField*)sender).text;
    UITextField *textField = ((UITextField*)sender);
    textField.rightViewMode = UITextFieldViewModeAlways;
    if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '4')
    {
        //Visa
         [self.cardTypeButton setImage:[UIImage imageNamed:@"Visa"] forState:UIControlStateNormal];
          self.cardType=@"Visa";
    }
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '5' && ([cc_num_string characterAtIndex:1] == '1' || [cc_num_string characterAtIndex:1] == '5'))
    {
        //Mastercard
        [self.cardTypeButton setImage:[UIImage imageNamed:@"Master Card"] forState:UIControlStateNormal];
          self.cardType=@"Master Card";
    }
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '6' && ([cc_num_string characterAtIndex:1] == '5' || ([cc_num_string length] > 2 &&[cc_num_string length] > 1 && [cc_num_string characterAtIndex:1] == '4' && [cc_num_string characterAtIndex:2] == '4') || ([cc_num_string length] > 3 && [cc_num_string characterAtIndex:1] == '0' && [cc_num_string characterAtIndex:2] == '1' && [cc_num_string characterAtIndex:3] == '1' )))
    {
        //Discover
        [self.cardTypeButton setImage:[UIImage imageNamed:@"Discover Network"] forState:UIControlStateNormal];
        self.cardType=@"Discover Network" ;
    }
    //American Express
    else if ([cc_num_string length] > 1 && [cc_num_string characterAtIndex:0] == '3' && ([cc_num_string characterAtIndex:1] == '4' || [cc_num_string characterAtIndex:1] == '7'))
    {
        [self.cardTypeButton setImage:[UIImage imageNamed:@"American Express"] forState:UIControlStateNormal];
        self.cardType=@"American Express" ;
    }
    // unionpay
    else if ([cc_num_string length ]>1 && [cc_num_string characterAtIndex:0] == '6' && [cc_num_string characterAtIndex:1] == '2')
    {
        if ([cc_num_string length] >2)
        {
            if([cc_num_string characterAtIndex:2] == '0' || [cc_num_string characterAtIndex:2] == '1' ||
               [cc_num_string characterAtIndex:2] == '2' || [cc_num_string characterAtIndex:2] == '3' ||
               [cc_num_string characterAtIndex:2] == '4' || [cc_num_string characterAtIndex:2] == '5')
            {
                [self.cardTypeButton setImage:[UIImage imageNamed:@"Union Pay"] forState:UIControlStateNormal];
                self.cardType=@"Union Pay" ;
            }
            else
                {
                [self.cardTypeButton setImage:Nil forState:UIControlStateNormal];
                self.cardType=@"";
                  }
              }
         }
    else{textField.rightView = nil;
    }
}

#pragma mark - TextField Delegate-
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.accountNoTextField)
    {
        NSUInteger newLength = [self.accountNoTextField.text length] + [string length] - range.length;
        return (newLength > 16) ? NO : YES;
    }
    else if (textField==self.cvcTextField)
    {
        NSUInteger newLength = [self.cvcTextField.text length] + [string length] - range.length;
        return (newLength > 3) ? NO : YES;
    }
  else
      return YES;
}
#pragma mark - TableView Delegate and DataSource Method-
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [cardTyeArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.cardTypeButton setImage:[UIImage imageNamed:[cardTyeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
    self.cardType=[cardTyeArray objectAtIndex:indexPath.row];
    [self.cardTypeTableView setHidden:YES];
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
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(5, 11, 120, 21)];
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
#pragma mark - UIPicker View Delegate-
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
       return [monthArray objectAtIndex:row];
    }
    else
    {
        return [yearArray objectAtIndex:row];
    }
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0)
    {
        return [monthArray count];
    }
    else
        return [yearArray count];
}
#pragma mark -Gesture Delegate-

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UITableView *tableView = self.cardTypeTableView;
    CGPoint touchPoint = [touch locationInView:tableView];
    return ![tableView hitTest:touchPoint withEvent:nil];
}
#pragma mark -Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Credit Card Validation Method
-(BOOL)checkCreditCardValidity
{
    
    CreditCardValidation *cc = [[CreditCardValidation alloc]init];
    if ([cc validateCard:self.accountNoTextField.text])
    {
        return YES ;
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Credit Card number invalid" message:@"Please enter valid number " delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
        [alert show];
        return NO ;
    }
}


@end
