//
//  PFavoriteDriverVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFavoriteDriverVC : UIViewController{
    NSDictionary     * favDriverDict;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
