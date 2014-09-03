//
//  PTaxiRequest.h
//  PaxiApp
//
//  Created by TarunMahajan on 13/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTaxiRequest : NSObject
@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strRequestId;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strUserImage;
@property(nonatomic,strong)NSString *strUserPhone;
@property(nonatomic,strong)NSString *strSourceAddress;
@property(nonatomic,strong)NSString *strDestinationAddress;
@property(nonatomic,strong)NSString *strDate;
@property(nonatomic,strong)NSString *strStatus;
@end
