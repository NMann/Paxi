//
//  PRouteViewController.h
//  PaxiApp
//
//  Created by TarunMahajan on 14/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PTaxiRequest.h"

@interface PRouteViewController : UIViewController<MKMapViewDelegate>
@property(nonatomic,strong)PTaxiRequest *taxiRequestDetail;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)m_ArrivedButtonPressed:(id)sender;

@end
