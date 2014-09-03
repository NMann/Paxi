//
//  PAppManager.m
//  PaxiApp
//
//  Created by TarunMahajan on 18/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "PAppManager.h"
static PAppManager *_sharedAppManager = nil;
@implementation PAppManager
+(PAppManager *)sharedData
{
    if (!_sharedAppManager)
        _sharedAppManager = [[PAppManager alloc] init];
    return _sharedAppManager;
}
-(NSString *)m_Getdate:(NSDate*)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    NSInteger day=[components day];
    NSString *dayString;
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    if (day==1||day==21||day==31)
    {
        dayString=[NSString stringWithFormat:@"%ldst",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[dateformat stringFromDate:date],dayString];
        [dateformat setDateFormat:@"yyyy"];
        dayString=[NSString stringWithFormat:@"%@,%@",dayString,[dateformat stringFromDate:date]];

    }
    else if (day==3)
    {
        dayString=[NSString stringWithFormat:@"%ldrd",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[dateformat stringFromDate:date],dayString];
        [dateformat setDateFormat:@"yyyy"];
        dayString=[NSString stringWithFormat:@"%@,%@",dayString,[dateformat stringFromDate:date]];
        
    }
    else if (day==2||day==22)
    {
        dayString=[NSString stringWithFormat:@"%ldnd",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[dateformat stringFromDate:date],dayString];
        [dateformat setDateFormat:@"yyyy"];
        dayString=[NSString stringWithFormat:@"%@,%@",dayString,[dateformat stringFromDate:date]];

    }
    else
    {
        dayString=[NSString stringWithFormat:@"%ldth",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[dateformat stringFromDate:date],dayString];
        [dateformat setDateFormat:@"yyyy"];
        dayString=[NSString stringWithFormat:@"%@,%@",dayString,[dateformat stringFromDate:date]];

    }
    return dayString;
}
-(NSString *)m_GetFormattedDate:(NSDate*)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit fromDate:date];
    NSInteger day=[components day];
    NSString *dayString;
    NSDateFormatter *dateformat=[[NSDateFormatter alloc]init];
    if (day==1||day==21||day==31)
    {
        dayString=[NSString stringWithFormat:@"%ldst",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[[dateformat stringFromDate:date]uppercaseString],dayString];
        [dateformat setDateFormat:@"EEE"];
        dayString=[NSString stringWithFormat:@"%@ \n%@.",dayString,[dateformat stringFromDate:date]];
        
    }
    else if (day==3)
    {
        dayString=[NSString stringWithFormat:@"%ldrd",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[[dateformat stringFromDate:date]uppercaseString],dayString];
        [dateformat setDateFormat:@"EEE"];
        dayString=[NSString stringWithFormat:@"%@ \n%@.",dayString,[dateformat stringFromDate:date]];
        
    }
    else if (day==2||day==22)
    {
        dayString=[NSString stringWithFormat:@"%ldnd",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[[dateformat stringFromDate:date]uppercaseString],dayString];
        [dateformat setDateFormat:@"EEE"];
        dayString=[NSString stringWithFormat:@"%@ \n%@.",dayString,[dateformat stringFromDate:date]];
        
    }
    else
    {
        dayString=[NSString stringWithFormat:@"%ldth",(long)day];
        [dateformat setDateFormat:@"MMMM"];
        dayString=[NSString stringWithFormat:@"%@ %@",[[dateformat stringFromDate:date]uppercaseString],dayString];
        [dateformat setDateFormat:@"EEE"];
        dayString=[NSString stringWithFormat:@"%@\n %@.",dayString,[dateformat stringFromDate:date]];
        
    }
    return dayString;
}
#pragma mark - Method To Add Padding-
-(void)m_AddPadding:(UITextField*)Sender
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    Sender.leftView = paddingView;
    Sender.leftViewMode = UITextFieldViewModeAlways;
}
#pragma mark - Change PlaceHolder TextColor-
-(void)m_ChangePLaceHolderColor:(UIColor*)color textField:(UITextField*)sender
{
     [sender setValue:color forKeyPath:@"_placeholderLabel.textColor"];
}
@end
