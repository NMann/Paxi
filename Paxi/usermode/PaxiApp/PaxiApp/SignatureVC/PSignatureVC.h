//
//  PSignatureVC.h
//  PaxiApp
//
//  Created by TarunMahajan on 22/07/14.
//  Copyright (c) 2014 Deftsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmoothLineView.h"

@protocol pSignature <NSObject>

-(void)SignatureImage:(UIImage*)image;

@end

@interface PSignatureVC : UIViewController
{
    CGPoint lastPoint;
    BOOL mouseSwiped;
}
@property(nonatomic,assign)id delegate;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet SmoothLineView *drawingView;

@end
