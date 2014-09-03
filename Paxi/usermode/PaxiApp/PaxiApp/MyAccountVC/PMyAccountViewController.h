//
//  PMyAccountViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 11/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMyAccountViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *accountTableView;

@end
