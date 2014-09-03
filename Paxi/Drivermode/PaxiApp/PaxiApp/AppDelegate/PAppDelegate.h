//
//  PAppDelegate.h
//  PaxiApp
//
//  Created by TarunMahajan on 09/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
     NSTimer *timer;
    UIApplication *app;
    NSDate *bgTimeStamp;
}
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
-(void)m_loadLoginView;
-(void)m_LoadHomeView;
+ ( PAppDelegate *)sharedAppDelegate;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
