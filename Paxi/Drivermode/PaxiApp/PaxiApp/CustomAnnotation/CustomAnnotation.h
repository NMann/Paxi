//
//  CustomAnnotation.h
//  PaxiApp
//
//  Created by Macmini 1 on 21/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CustomAnnotation : NSObject<MKAnnotation>
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate ;
@property(copy,nonatomic)NSString *title ;
-(id)initWithTitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location;
-(MKAnnotationView*)annotationView ;


@end
