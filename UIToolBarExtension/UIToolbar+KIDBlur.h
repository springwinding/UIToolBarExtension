//
//  UIToolbar+KIDBlur.h
//  UIToolBarExtension
//
//  Created by JiangYan on 15/11/2.
//  Copyright © 2015年 Mybabay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar(KIDBlur)

+ (UIColor *)kid_tintColor;
+ (void)setKid_tintColor:(UIColor *)kid_tintColor;
+ (CGFloat)kid_tintAlpha;
+ (void)setKid_tintAlpha:(CGFloat)tintAlpha;
+(CGFloat)kid_blurRadius;
+(void)setKid_blurRadius:(CGFloat)blurRadius;

@end
