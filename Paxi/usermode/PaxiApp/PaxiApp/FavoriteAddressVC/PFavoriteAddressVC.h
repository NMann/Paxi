//
//  PFavoriteAddressVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PFavoriteAddressVCDelegate <NSObject>
-(void)addquestions:(NSString*)str;
@end

@interface PFavoriteAddressVC : UIViewController
{
    NSString *favAdd ;
    NSMutableArray *favaddressArray;
}
@property(nonatomic,retain)id<PFavoriteAddressVCDelegate>  delegate;
@property(nonatomic,strong) IBOutlet UITableView *m_AddressTableview ;
@end
