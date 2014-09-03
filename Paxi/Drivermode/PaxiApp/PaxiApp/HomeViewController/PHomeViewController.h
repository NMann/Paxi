//
//  PHomeViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PHomeViewController : UIViewController{
    NSString *airportrequests;
    NSString *taxirequests;
}
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_airportrequest;
@property (strong, nonatomic) IBOutlet UIButton *m_taxirequest;

@end
