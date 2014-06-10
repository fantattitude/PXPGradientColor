//
//  ViewController.h
//  PXPGradientColorSampleObjC
//
//  Created by Louka Desroziers on 10/06/2014.
//  Copyright (c) 2014 PixiApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PXPGradientColor.h"

@interface PXPGradientGeometryView : UIView
@property (nonatomic, assign) CGFloat               angle;
@property (nonatomic, strong) PXPGradientColor      *gradient;
@property (nonatomic, strong) UIBezierPath          *bezierPath;
@end

@interface ViewController : UIViewController


@end

