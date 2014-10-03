//
//  CustomAnnotation.m
//  PaxiApp
//
//  Created by Macmini 1 on 21/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize title = _title ;
@synthesize coordinate = _coordinate ;
-(id)initWithTitle:(NSString*)newTitle Location:(CLLocationCoordinate2D)location
{
    self = [super init];
    if(self)
    {
        _title = newTitle ;
        _coordinate = location ;
    }
    return  self ;
}

-(MKAnnotationView*)annotationView
{
    MKAnnotationView *mkAnnotationView = [[MKAnnotationView alloc]initWithAnnotation:self reuseIdentifier:@"CustomAnnotation"] ;
    mkAnnotationView.enabled = YES ;
    mkAnnotationView.canShowCallout = YES ;
    mkAnnotationView.image = [UIImage imageNamed:@"marker.png"] ;
    mkAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure] ;
    return mkAnnotationView ;
}
@end
