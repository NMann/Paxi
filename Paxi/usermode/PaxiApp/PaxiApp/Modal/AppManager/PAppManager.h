//
//  PAppManager.h
//  PaxiApp
//
//  Created by TarunMahajan on 18/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAppManager : NSObject
+(PAppManager *)sharedData;
-(NSString *)m_Getdate:(NSDate*)date;
-(NSString *)m_GetFormattedDate:(NSDate*)date;
-(void)m_AddPadding:(UITextField*)Sender;
-(void)m_ChangePLaceHolderColor:(UIColor*)color textField:(UITextField*)sender;
@end
