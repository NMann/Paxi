//
//  PApiCall.h
//  PaxiApp
//
//  Created by TarunMahajan on 24/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^JSONResponseBlock)(NSDictionary* json);

@interface PApiCall : NSObject
+(PApiCall*)sharedInstance;
-(void)m_GetApiResponse:(NSString*)methodName parameters:(NSString*)param onCompletion:(JSONResponseBlock)completionBlock;
-(NSString *)uploadimage:(NSData*)imagedata;
@end
