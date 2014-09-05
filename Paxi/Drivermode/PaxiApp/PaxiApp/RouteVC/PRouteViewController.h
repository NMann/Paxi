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
#import <GoogleMaps/GoogleMaps.h>

@interface PRouteViewController : UIViewController<GMSMapViewDelegate>
@property(nonatomic,strong)PTaxiRequest *taxiRequestDetail;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *m_mapViewContainer;
- (IBAction)m_ArrivedButtonPressed:(id)sender;

@end
