//
//  PMyAccountCustomcell.m
//  PaxiApp
//
//  Created by Ankush Sharma on 25/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PMyAccountCustomcell.h"


@implementation PMyAccountCustomcell
@synthesize m_DateLabel ,m_AmountLabel ,DetailtableViewInsideCell ;

- (void)awakeFromNib
{
  // [ DetailtableViewInsideCell setFrame:CGRectMake(DetailtableViewInsideCell.frame.origin.x, DetailtableViewInsideCell.frame.origin.y, DetailtableViewInsideCell.frame.size.width,(34.0f*(2))) ];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:CellIdentifier] ;
    }
    
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
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 34.0f;
}
@end
