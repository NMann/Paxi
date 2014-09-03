//
//  PTaxiRequestVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTaxiRequestVC : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *requestTableView;
@property(nonatomic,readwrite)BOOL isAirPort;
@end
