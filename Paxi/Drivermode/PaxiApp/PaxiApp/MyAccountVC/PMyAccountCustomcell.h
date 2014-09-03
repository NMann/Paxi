//
//  PMyAccountCustomcell.h
//  PaxiApp
//
//  Created by Ankush Sharma on 25/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMyAccountCustomcell : UITableViewCell <UITableViewDelegate, UITableViewDataSource> {
    NSDictionary *data;
}

@property (nonatomic, retain) IBOutlet UITableView *DetailtableViewInsideCell;
@property (strong, nonatomic) IBOutlet UILabel *m_DateLabel;
@property (strong, nonatomic) IBOutlet UILabel *m_AmountLabel;

@end
