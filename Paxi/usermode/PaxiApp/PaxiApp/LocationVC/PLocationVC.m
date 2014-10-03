//
//  PLocationVC.m
//  PaxiApp
//
//  Created by TarunMahajan on 15/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PLocationVC.h"
#import "PCarTypeVC.h"
@interface PLocationVC ()
{
    NSMutableData *webData;
    NSMutableArray *locationNameArray;
}
@end

@implementation PLocationVC

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
    [[PAppManager sharedData] m_AddPadding:self.locationTextField];
    /* change Place Holder Color*/
    [[PAppManager sharedData]m_ChangePLaceHolderColor:[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0] textField:self.locationTextField];
    webData=[[NSMutableData alloc]init];
    locationNameArray=[[NSMutableArray alloc]init];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(m_SearchLocation:)
                                                name:UITextFieldTextDidChangeNotification object:self.locationTextField];

    [self m_AddNavigationBarItem];
    self.locationTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}
#pragma mark - Method To add Navigation Bar item-
-(void)m_AddNavigationBarItem
{
    [self.navigationItem setHidesBackButton:YES];
    
    self.navigationItem.title=@"Drop-off Location";
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                    [UIColor whiteColor],NSBackgroundColorAttributeName,nil];
    
    self.navigationController.navigationBar.titleTextAttributes = textAttributes;
    
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Back"] style:UIBarButtonItemStylePlain target:self action:@selector(m_BackButtonPressed:)];
    self.navigationItem.leftBarButtonItem=backButton;
    
    UIBarButtonItem *homeButton=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(m_HomeButtonPressed:)];
    self.navigationItem.rightBarButtonItem=homeButton;
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
-(IBAction)m_SearchLocation:(id)sender
{
    if ([self.locationTextField.text length]>0)
    {
        NSString *urlString=[[NSString stringWithFormat:@"%@getLocations&keyword=%@",BaseURLString,self.locationTextField.text] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURLRequest *Request=[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
        NSURLConnection  *Connection=[[NSURLConnection alloc]initWithRequest:Request delegate:self];
        NSLog(@"%@",Connection);
    }
   }
#pragma mark-
#pragma mark - NSURL Connection  Delegate-

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [webData setLength:0];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@",error.description);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [webData appendData:data];
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  //  NSString *strResult =[[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *responseDict=[NSJSONSerialization JSONObjectWithData:webData options:NSJSONReadingAllowFragments error:nil ];
    NSLog(@"%@",responseDict);
    if ([[responseDict objectForKey:@"return"] integerValue]==1)
    {
        [locationNameArray removeAllObjects];
        [locationNameArray addObjectsFromArray:[[responseDict objectForKey:@"data"] valueForKey:@"locationname"]];
        [self.locationTableView reloadData];
    }
}
#pragma mark - TableView Delegate and DataSource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return [locationNameArray count];
   // return [locationNameArray count]+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row<[locationNameArray count])
//    {
//        PCarTypeVC *carTypeVC=[[PCarTypeVC alloc]initWithNibName:@"PCarTypeVC" bundle:nil];
//        carTypeVC.strDepartureDate=self.strDepartureDate;
//        carTypeVC.strDestination=self.strDestination;
//        carTypeVC.strFlightNo=self.strFlightNo;
//        carTypeVC.strPassengerName=self.strPassengerName;
//        carTypeVC.strDropOffLocation=[locationNameArray objectAtIndex:indexPath.row];
//        [self.navigationController pushViewController:carTypeVC animated:YES];
//
//    }
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
    
    UIImageView *pinImage=[[UIImageView alloc]init];
    pinImage.frame=CGRectMake(18, 11, 21, 27);
    [pinImage setImage:[UIImage imageNamed:@"pin"]];
    [cell.contentView addSubview:pinImage];
    
    UIButton *selectionButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [selectionButton setFrame:CGRectMake(276, 7, 36, 36)];
       [cell.contentView addSubview:selectionButton];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 15, 220, 21)];
    [titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:17.0]];
    titleLabel.textColor=[UIColor colorWithRed:149/255.0 green:200/255.0 blue:201/255.0 alpha:1.0];
    if ([locationNameArray count]>1 &&indexPath.row!=[locationNameArray count])
    {
        titleLabel.text=[locationNameArray objectAtIndex:indexPath.row];
        //[selectionButton setImage:[UIImage imageNamed:@"editYellowButton"] forState:UIControlStateNormal];
        selectionButton.layer.cornerRadius=18.0;
        selectionButton.layer.borderColor=[UIColor whiteColor].CGColor;
        selectionButton.layer.borderWidth=1.0;
        [selectionButton.layer setMasksToBounds:YES];
        if ([self.strLocation isEqualToString:[locationNameArray objectAtIndex:indexPath.row]])
        {
            [selectionButton setImage:[UIImage imageNamed:@"checkIcon"] forState:UIControlStateNormal];

        }
        [selectionButton addTarget:self action:@selector(m_LocationSelected:) forControlEvents:UIControlEventTouchUpInside];
        [selectionButton setTag:indexPath.row+100];
    }
    [cell.contentView addSubview:titleLabel];
  /*  if (indexPath.row==[locationNameArray count])
    {
        pinImage.frame=CGRectMake(18, 23, 22, 4);
        [pinImage setImage:[UIImage imageNamed:@"dot"]];
        titleLabel.text=@"More Locations";
        [selectionButton setImage:[UIImage imageNamed:@"nextIcon"] forState:UIControlStateNormal];

    }*/
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
-(IBAction)m_LocationSelected:(id)sender
{
    for (int i=0; i<[locationNameArray count]; i++)
    {
        [(UIButton*)[self.view viewWithTag:i+100] setImage:nil forState:UIControlStateNormal];
    }
    [sender setImage:[UIImage imageNamed:@"checkIcon"] forState:UIControlStateNormal];
    self.strLocation=[locationNameArray objectAtIndex:[sender tag]-100];
}
- (IBAction)m_CarTypeButtonPressed:(id)sender
{
//    if ([self.strLocation length]>0)
//    {
        PCarTypeVC *carTypeVC=[[PCarTypeVC alloc]initWithNibName:@"PCarTypeVC" bundle:nil];
        carTypeVC.strDepartureDate=self.strDepartureDate;
        carTypeVC.strDestination=self.strDestination;
        carTypeVC.strFlightNo=self.strFlightNo;
        carTypeVC.strPassengerName=self.strPassengerName;
        carTypeVC.strDropOffLocation=self.strLocation;
        [self.navigationController pushViewController:carTypeVC animated:YES];
//    }
//   else
//   {
//       [SVProgressHUD showErrorWithStatus:@"PLease select Drop-off Location."];
//   }
}

#pragma mark - TextField Delegate-
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"Drop-off Location"])
    {
        textField.text=@"";
    }
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""] ||[textField.text isEqualToString:@" "])
    {
        textField.text=@"Drop-off Location";
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
