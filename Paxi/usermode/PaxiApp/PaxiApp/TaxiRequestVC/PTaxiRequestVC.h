//
//  PTaxiRequestVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 17/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFavoriteAddressVC.h"

@interface PTaxiRequestVC : UIViewController<UITextFieldDelegate,MKMapViewDelegate,PFavoriteAddressVCDelegate>
{
    NSString *pickuplocation;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)m_DoneButtonPressed:(id)sender;
- (IBAction)m_FavoritesButtonPressed:(id)sender;
- (IBAction)m_TaxiButtonPressed:(id)sender;
- (IBAction)m_MyPaxiButtonPressed:(id)sender;

@end
