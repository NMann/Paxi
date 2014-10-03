//
//  PMyAccountViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMyAccountViewController.h"

@interface PMyAccountViewController ()

@end

@implementation PMyAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
#pragma mark - Life Cycle Method-
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self m_AddNavigationBarItem];
    self.accountTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Do any additional setup after loading the view from its nib.
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
   [self dismissViewControllerAnimated:NO completion:nil];
}
-(IBAction)m_BackButtonPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - TableView Delegate And Datasource Method-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentif = @"Cell";
    UITableViewCell *cell=(UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==Nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentif];
        
        [cell setBackgroundColor:[UIColor clearColor]];
        
    }
   
    UILabel *dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 12, 100, 20)];
    dateLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:15.0];
    dateLabel.text=@"4/24/2014";
    dateLabel.textColor=[UIColor colorWithRed:62/255.0 green:136/255.0 blue:161/255.0 alpha:1.0];
    [cell.contentView addSubview:dateLabel];
   
    UILabel *seperatorLine=[[UILabel alloc] initWithFrame:CGRectMake(110, 10, 1, 24)];
    seperatorLine.backgroundColor=[UIColor colorWithRed:62/255.0 green:136/255.0 blue:161/255.0 alpha:1.0];
    [cell.contentView addSubview:seperatorLine];
    
    UILabel * detailLabel=[[UILabel alloc]init];
    detailLabel.textColor=[UIColor colorWithRed:62/255.0 green:136/255.0 blue:161/255.0 alpha:1.0];
    detailLabel.textAlignment=NSTextAlignmentRight;
    [cell.contentView addSubview:detailLabel];
    detailLabel.text=@"$20";
    detailLabel.frame=CGRectMake(120, 12, 150, 20);
    if (indexPath.section==0)
    {
        detailLabel.frame=CGRectMake(120, 12, 110, 20);
        detailLabel.text=@"****1289";
        UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"Master Card"] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(240, 11, 32, 22)];
        [cell.contentView addSubview:button];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 280, 25)];
    UIImageView *headerImage=[[UIImageView alloc]initWithFrame:view.bounds];
    [view addSubview:headerImage];
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, 25)];
    titleLabel.font=[UIFont fontWithName:@"Helvetica Neue" size:15.0];
    [view addSubview:titleLabel];
   
    if (section==0)
    {
        [headerImage setImage:[UIImage imageNamed:@"blueHeader"]];
        titleLabel.text=@"Payment Method";
        titleLabel.textColor=[UIColor colorWithRed:62/255.0 green:136/255.0 blue:161/255.0 alpha:1.0];
        
        }
    else  if (section==1)
    {
        titleLabel.text=@"Pending";
        [headerImage setImage:[UIImage imageNamed:@"greenHeader"]];
        titleLabel.textColor=[UIColor colorWithRed:113/255.0 green:135/255.0 blue:58/255.0 alpha:1.0];
    }
    else if (section==2)
    {
        titleLabel.text=@"Completed";
        [headerImage setImage:[UIImage imageNamed:@"yellowHeader"]];
        titleLabel.textColor=[UIColor colorWithRed:166/255.0 green:131/255.0 blue:40/255.0 alpha:1.0];

       
    }
    return view;

}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
}
#pragma mark -Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
