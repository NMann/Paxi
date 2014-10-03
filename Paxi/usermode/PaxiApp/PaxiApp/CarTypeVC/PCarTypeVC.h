//
//  PCarTypeVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 16/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCarTypeVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSString *strFlightNo;
@property(nonatomic,strong)NSString *strDepartureDate;
@property(nonatomic,strong)NSString *strDestination;
@property(nonatomic,strong)NSString *strPassengerName;
@property(nonatomic,strong)NSString *strDropOffLocation;
@property(nonatomic,strong)NSString *strCarId;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *name1Label;
@property (weak, nonatomic) IBOutlet UILabel *passenger1Label;
@property (weak, nonatomic) IBOutlet UILabel *luggage1Label;
@property (weak, nonatomic) IBOutlet UILabel *name2Label;
@property (weak, nonatomic) IBOutlet UILabel *luggage2Label;
@property (weak, nonatomic) IBOutlet UILabel *passenger2Label;
@property (weak, nonatomic) IBOutlet UILabel *name3Label;
@property (weak, nonatomic) IBOutlet UILabel *passenger3Label;
@property (weak, nonatomic) IBOutlet UILabel *luggage3Label;
@property (weak, nonatomic) IBOutlet UILabel *name4Label;
@property (weak, nonatomic) IBOutlet UILabel *passenger4Label;
@property (weak, nonatomic) IBOutlet UILabel *luggage4Label;
- (IBAction)m_MoreButtonPressed:(id)sender;
- (IBAction)m_ConfirmationButtonPressed:(id)sender;
- (IBAction)m_carSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *selectedCarImage;
@property (strong, nonatomic) IBOutlet UICollectionView *CarCollectionView;

@end
