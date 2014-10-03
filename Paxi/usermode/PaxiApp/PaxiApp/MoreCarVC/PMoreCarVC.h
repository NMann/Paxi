//
//  PMoreCarVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMoreCarVC : UIViewController

@property(strong,nonatomic)NSMutableArray *carTypeArray;
@property(nonatomic,strong)NSString *strFlightNo;
@property(nonatomic,strong)NSString *strDepartureDate;
@property(nonatomic,strong)NSString *strDestination;
@property(nonatomic,strong)NSString *strPassengerName;
@property(nonatomic,strong)NSString *strDropOffLocation;


@property (weak, nonatomic) IBOutlet UITableView *moreCarTableView;
@end
