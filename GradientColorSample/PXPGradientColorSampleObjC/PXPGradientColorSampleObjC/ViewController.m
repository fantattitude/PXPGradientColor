//
//  ViewController.m
//  PXPGradientColorSampleObjC
//
//  Created by Louka Desroziers on 10/06/2014.
//  Copyright (c) 2014 PixiApps. All rights reserved.
//

#import "ViewController.h"

@implementation PXPGradientGeometryView

- (void)setBezierPath:(UIBezierPath *)bezierPath
{
    if(_bezierPath != bezierPath)
    {
        _bezierPath = bezierPath;
        [self setNeedsDisplay];
    }
}

- (void)setGradient:(PXPGradientColor *)gradient
{
    if(_gradient != gradient)
    {
        _gradient = gradient;
        [self setNeedsDisplay];
    }
}

- (void)setAngle:(CGFloat)angle
{
    if(_angle != angle)
    {
        _angle = angle;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    if([self gradient] != nil)
    {
        [[self gradient] drawInBezierPath:([self bezierPath] == nil ? [UIBezierPath bezierPathWithRect:rect] : [self bezierPath])
                                    angle:[self angle]];
    }
    else
    {
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(ctx);
        CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
        
        CGContextAddPath(ctx, [([self bezierPath] == nil ? [UIBezierPath bezierPathWithRect:rect] : [self bezierPath]) CGPath]);
        CGContextFillPath(ctx);
        
        CGContextRestoreGState(ctx);
        
    }
}


@end

@interface ViewController ()
            
@property (nonatomic, strong) IBOutlet UISlider *angleSlider;
@property (nonatomic, strong) IBOutlet PXPGradientGeometryView *rectangleView, *ovalView, *triangleView;

@end

@implementation ViewController
            
- (UIBezierPath *)__triangleBezierPathForFrame:(CGRect)frame
{
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    [trianglePath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame))];
    [trianglePath addLineToPoint:CGPointMake(CGRectGetMaxX(frame), CGRectGetMinY(frame))];
    [trianglePath closePath];
    
    return trianglePath;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self angleSlider] addTarget:self
                           action:@selector(angleValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
    
    
    [[self ovalView] setGradient:[PXPGradientColor gradientWithColors:@[[UIColor redColor],
                                                                        [UIColor greenColor],
                                                                        [UIColor blackColor],
                                                                        [UIColor blueColor],
                                                                        [UIColor yellowColor]
                                                                        ]]];
    [[self ovalView] setBezierPath:[UIBezierPath bezierPathWithOvalInRect:[[self ovalView] bounds]]];
    
    
    [[self rectangleView] setGradient:[PXPGradientColor gradientWithColors:@[[UIColor redColor],
                                                                             [UIColor greenColor],
                                                                             [UIColor blackColor],
                                                                             [UIColor blueColor],
                                                                             [UIColor yellowColor]
                                                                             ]]];
    [[self rectangleView] setBezierPath:nil];
    
    
    [[self triangleView] setGradient:[PXPGradientColor gradientWithStartingColor:[UIColor grayColor] endingColor:[UIColor redColor]]];
    [[self triangleView] setBezierPath:[self __triangleBezierPathForFrame:[[self triangleView] bounds]]];
    
}


- (void)angleValueChanged:(UISlider *)sender
{
    [[self ovalView] setAngle:[sender value]];
    [[self rectangleView] setAngle:[sender value]];
    [[self triangleView] setAngle:[sender value]];
    
}


@end
