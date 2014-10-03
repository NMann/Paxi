//
//  PLocationVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 15/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLocationVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong)NSString *strFlightNo;
@property(nonatomic,strong)NSString *strDepartureDate;
@property(nonatomic,strong)NSString *strDestination;
@property(nonatomic,strong)NSString *strPassengerName;
@property(nonatomic,strong)NSString *strLocation;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UITableView *locationTableView;
- (IBAction)m_CarTypeButtonPressed:(id)sender;

@end
