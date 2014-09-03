//
//  PMyAccountViewController.m
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMyAccountViewController.h"
#import "PMyAccountCustomcell.h"
#import "PMyAccountDetailViewController.h"

@interface PMyAccountViewController ()

@end

@implementation PMyAccountViewController
@synthesize DetailtableViewInsideCell;

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
    self.m_mainAccountTableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   
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
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -Memory Management Method-
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Table View Delegates

#pragma mark - TableView Delegate-
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.m_mainAccountTableview){
           return 2;
    } else {
        return 3;
    }
 
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if(tableView == self.m_mainAccountTableview){
     return (34.0f*(3)) ;
     }else{
        return 34.0f; 
     }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   if(tableView == self.m_mainAccountTableview){
    
    }else{
        PMyAccountDetailViewController *newVC=[[PMyAccountDetailViewController alloc]initWithNibName:@"PMyAccountDetailViewController" bundle:nil];
        [self.navigationController pushViewController:newVC animated:YES];
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.m_mainAccountTableview) {
        
    static NSString *cellIdentif = @"Cell";
    PMyAccountCustomcell *cell=(PMyAccountCustomcell*)[tableView dequeueReusableCellWithIdentifier:cellIdentif];
    if (cell==nil)
    {
        NSArray *nib=[[NSBundle mainBundle]loadNibNamed:@"PMyAccountCustomcell" owner:self options:nil];
        
        cell=[nib objectAtIndex:0];
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
        // vertical line
        
        UILabel *linelabel =[[UILabel alloc]initWithFrame:CGRectMake(105.5,0,0.5,cell.frame.size.height) ];
        [linelabel setBackgroundColor:[UIColor colorWithRed:127/255.0 green:199/255.0 blue:197/255.0 alpha:1.0]];
        [ cell addSubview:linelabel];
        
         // inside tableview
        DetailtableViewInsideCell=[[UITableView alloc]initWithFrame :CGRectMake(106,2,265,116) ];
        DetailtableViewInsideCell.backgroundColor =[UIColor clearColor];
        DetailtableViewInsideCell.separatorStyle =UITableViewCellSeparatorStyleNone;
        DetailtableViewInsideCell.dataSource=self;
        DetailtableViewInsideCell.delegate=self;
        DetailtableViewInsideCell.scrollEnabled = NO ;
        [ cell addSubview:DetailtableViewInsideCell];
       
        // horizontal line
      //  UILabel *bottomlabel =[[UILabel alloc]initWithFrame:CGRectMake(0,0,cell.frame.size.width ,0.5) ];
      //  [bottomlabel setBackgroundColor:[UIColor colorWithRed:127/255.0 green:199/255.0 blue:197/255.0 alpha:1.0]];
      //   [ cell addSubview:bottomlabel];
        
      return cell;
    
    }else{
  
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:CellIdentifier] ;
    }
      cell.selectionStyle=UITableViewCellSelectionStyleNone;
    // Configure the cell...
    cell.textLabel.text = @"10111111";
    [cell.textLabel setFont:[UIFont systemFontOfSize:15]];
    cell.textLabel.textColor =[UIColor colorWithRed:127/255.0 green:199/255.0 blue:197/255.0 alpha:1.0];
    
    UILabel *amountlabel = [[UILabel alloc] initWithFrame:CGRectMake(140,0,80,30)];
    UIColor *titlebg = [UIColor clearColor];
    [ amountlabel setBackgroundColor:titlebg];
    amountlabel.text = @"$17.56";
    [amountlabel setFont:[UIFont systemFontOfSize:15]];
    amountlabel.textColor =[UIColor colorWithRed:127/255.0 green:199/255.0 blue:197/255.0 alpha:1.0];
    [cell addSubview:amountlabel];
    
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(tableView == self.m_mainAccountTableview) {
      [cell setBackgroundColor:[UIColor clearColor]];
  }else{
    [cell setBackgroundColor:[UIColor clearColor]];
    if (indexPath.row %2==0)
    {
        
        [cell setBackgroundColor:[UIColor clearColor]];
    }
    else
    {
        [cell setBackgroundColor:[UIColor colorWithRed:33/255.0 green:61/255.0 blue:89/255.0 alpha:0.2]];
        
    }
}
}
@end
