//
//  PAirportRequest.h
//  PaxiApp
//
//  Created by TarunMahajan on 07/08/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PAirportRequest : NSObject
@property(nonatomic,strong)NSString *strUserId;
@property(nonatomic,strong)NSString *strRequestId;
@property(nonatomic,strong)NSString *strSignatureImage;
@property(nonatomic,strong)NSString *strAirportService;
@property(nonatomic,strong)NSString *strBasicFee;
@property(nonatomic,strong)NSString *strTotalFee;
@property(nonatomic,strong)NSString *strUserName;
@property(nonatomic,strong)NSString *strUserImage;
@property(nonatomic,strong)NSString *strUserPhone;
@property(nonatomic,strong)NSString *strUserSignature;
@property(nonatomic,strong)NSString *strDepartureDate;
@property(nonatomic,strong)NSString *strFlightNo;
@property(nonatomic,strong)NSString *strSourceAddress;
@property(nonatomic,strong)NSString *strDestinationAddress;
@property(nonatomic,strong)NSString *strStatus;

@end
