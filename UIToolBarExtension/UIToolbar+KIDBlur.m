//
//  UIToolbar+KIDBlur.m
//  UIToolBarExtension
//
//  Created by JiangYan on 15/11/2.
//  Copyright © 2015年 Mybabay. All rights reserved.
//

#import "UIToolbar+KIDBlur.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSObject+MirrorMethod.h"

@implementation UIToolbar(KIDBlur)

+(void)load{
//    _UIBackdropViewinitWithFrame:autosizesToFitSuperview:settings:
    Class klass = NSClassFromString(@"_UIBackdropView");
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL selector = @selector(initWithFrame:autosizesToFitSuperview:settings:);
#pragma clang diagnostic pop
//    IMP implemention = class_getMethodImplementation(klass, selector);
    Method method   = class_getInstanceMethod(klass, selector);
    if (method) {
        [klass mirror_orginMethod:NSStringFromSelector(selector) isMeta:NO];
        const char *typeEncoding = method_getTypeEncoding(method);
        class_replaceMethod(klass, selector, kid_aspect_getMsgForwardIMP(klass, selector), typeEncoding);
        class_replaceMethod(klass, @selector(forwardInvocation:), (IMP)__KID_ASPECTS_ARE_BEING_CALLED__, "v@:@");
    }
}

+ (UIColor *)kid_tintColor{
    return objc_getAssociatedObject(self, _cmd);
}

+ (void)setKid_tintColor:(UIColor *)kid_tintColor{
    objc_setAssociatedObject(self, @selector(kid_tintColor), kid_tintColor, OBJC_ASSOCIATION_RETAIN);
}

+ (CGFloat)kid_tintAlpha{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

+ (void)setKid_tintAlpha:(CGFloat)kid_tintAlpha{
    objc_setAssociatedObject(self, @selector(kid_tintAlpha), @(kid_tintAlpha), OBJC_ASSOCIATION_RETAIN);
}

+(CGFloat)kid_blurRadius{
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

+(void)setKid_blurRadius:(CGFloat)kid_blurRadius{
   objc_setAssociatedObject(self, @selector(kid_blurRadius), @(kid_blurRadius), OBJC_ASSOCIATION_RETAIN);
}
//initWithFrame:autosizesToFitSuperview:settings:
static IMP kid_aspect_getMsgForwardIMP(id self, SEL selector) {
    IMP msgForwardIMP = _objc_msgForward;
#if !defined(__arm64__)
    // As an ugly internal runtime implementation detail in the 32bit runtime, we need to determine of the method we hook returns a struct or anything larger than id.
    // https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/000-Introduction/introduction.html
    // https://github.com/ReactiveCocoa/ReactiveCocoa/issues/783
    // http://infocenter.arm.com/help/topic/com.arm.doc.ihi0042e/IHI0042E_aapcs.pdf (Section 5.4)
    Method method = class_getInstanceMethod(self, selector);
    const char *encoding = method_getTypeEncoding(method);
    BOOL methodReturnsStructValue = encoding[0] == _C_STRUCT_B;
    if (methodReturnsStructValue) {
        @try {
            NSUInteger valueSize = 0;
            NSGetSizeAndAlignment(encoding, &valueSize, NULL);
            
            if (valueSize == 1 || valueSize == 2 || valueSize == 4 || valueSize == 8) {
                methodReturnsStructValue = NO;
            }
        } @catch (NSException *e) {}
    }
    if (methodReturnsStructValue) {
        msgForwardIMP = (IMP)_objc_msgForward_stret;
    }
#endif
    return msgForwardIMP;
}
//kidmirror
static void __KID_ASPECTS_ARE_BEING_CALLED__(id self, SEL selector, NSInvocation *invocation) {
    NSCParameterAssert(self);
    NSCParameterAssert(invocation);
    
    if ([NSStringFromSelector(invocation.selector) isEqualToString:@"initWithFrame:autosizesToFitSuperview:settings:"]) {
        if (UIToolbar.kid_tintColor && (UIToolbar.kid_tintAlpha < 1)) {
            __unsafe_unretained id arg;
            [invocation getArgument:&arg atIndex:4];
            [arg setValue:@(UIToolbar.kid_blurRadius) forKey:@"_blurRadius"];
            [arg setValue:UIToolbar.kid_tintColor forKey:@"colorTint"];
            [arg setValue:@(UIToolbar.kid_tintAlpha)  forKey:@"colorTintAlpha"];
            UIToolbar.kid_tintColor = nil;
            UIToolbar.kid_tintAlpha = 0.0f;
        }
    }
    
    SEL aliasSelector = kid_aspect_aliasForSelector(invocation.selector);
    invocation.selector = aliasSelector;
    
    Class klass = object_getClass(invocation.target);
    BOOL respondsToAlias = YES;
    do {
        if ((respondsToAlias = [klass instancesRespondToSelector:aliasSelector])) {
            [invocation invoke];
            break;
        }
    }while (!respondsToAlias && (klass = class_getSuperclass(klass)));
}

static SEL kid_aspect_aliasForSelector(SEL selector){
    NSString *mirror = [NSString stringWithFormat:@"kidmirror%@",NSStringFromSelector(selector)];
    return NSSelectorFromString(mirror);
    
}

@end
