//
//  PConfirmationVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 17/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PEvaluationVC : UIViewController{
    int rating;
    bool isLIKE;
}
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *destinationAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *driverNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *DoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *LikeBtn;

-(IBAction)m_statBtnAction:(id)sender;
-(IBAction)m_doneBtnAction:(id)sender;
-(IBAction)m_likeBtnAction:(id)sender;


@end
