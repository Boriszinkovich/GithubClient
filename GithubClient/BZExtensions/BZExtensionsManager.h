//
//  BZExtensionsManager.h
//  ScrollViewTask
//
//  Created by BZ on 2/15/16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSObject+BZExtensions.h"
#import "UIImageView+BZExtensions.h"
#import "UIView+BZExtensions.h"
#import "UIColor+BZExtensions.h"
#import "UIImage+BZExtensions.h"
#import "NSArray+BZExtensions.h"
#import "NSDictionary+BZExtensions.h"
#import "BZPageView.h"
#import "SMPageControl.h"
#import "BZAnimation.h"
#import "Reachability.h"
#import "BZUrlSession.h"
#import "EXTScope.h"

BOOL isEqual(id _Nullable theObject1, id _Nullable theObject2);

@interface BZExtensionsManager : NSObject

+ (void)methodAsyncMainWithBlock:(void (^ _Nonnull)())theBlock;
+ (void)methodAsyncBackgroundWithBlock:(void (^ _Nonnull)())theBlock;
+ (void)methodDispatchAfterSeconds:(double)theSeconds
                         withBlock:(void (^ _Nonnull)())theBlock;

@end






























