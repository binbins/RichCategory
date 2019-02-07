//
//  UIView+GDRotate.m
//  GDCategory
//
//  Created by yunfenghan Ling on 2017/11/10.
//

#import "UIView+GDRotate.h"

@implementation UIView (GDRotate)

- (void)setRotateDegree:(CGFloat)rotateDegree {
    self.transform = CGAffineTransformMakeRotation((rotateDegree * M_PI) / 180.0f);
}

- (CGFloat)rotateDegree {
    return self.rotateDegree;
}

@end
