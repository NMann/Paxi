//
//  PRouteViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@interface PRouteViewController : UIViewController<MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property(nonatomic,strong)IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *m_routeDetailButton;


@property(nonatomic,strong)NSString *strSourceAddress;
@property(nonatomic,strong)NSString *strDestinationAddress;


- (IBAction)m_SendButtonPressed:(id)sender;
- (IBAction)m_DetailButtonPressed:(id)sender;
- (IBAction)downButtonPressed:(id)sender;


@end
