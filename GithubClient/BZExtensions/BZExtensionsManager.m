//
//  BZExtensionsManager.m
//  ScrollViewTask
//
//  Created by BZ on 2/15/16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZExtensionsManager.h"

BOOL isEqual(id _Nullable theObject1, id _Nullable theObject2)
{
    if (!theObject1 && !theObject2)
    {
        return YES;
    }
    return [theObject1 isEqual:theObject2];
}

@implementation BZExtensionsManager

#pragma mark - Class Methods (Public)

+ (void)methodDispatchAfterSeconds:(double)theSeconds
                         withBlock:(void (^ _Nonnull)())theBlock
{
    if (![NSThread isMainThread] || !theBlock || theSeconds < 0)
    {
        abort();
    }
    [self performSelector:@selector(selectorWithBlock:) withObject:theBlock afterDelay:theSeconds];
}

+ (void)methodAsyncMainWithBlock:(void (^ _Nonnull)())theBlock
{
    if (!theBlock)
    {
        abort();
    }
    dispatch_async(dispatch_get_main_queue(), theBlock);
}

+ (void)methodAsyncBackgroundWithBlock:(void (^ _Nonnull)())theBlock
{
    if (!theBlock)
    {
        abort();
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), theBlock);
}

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

#pragma mark - Getters (Private)

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

#pragma mark - Methods (Private)

+ (void)selectorWithBlock:(void (^ _Nonnull)())theBlock
{
    theBlock();
}

#pragma mark - Standard Methods

@end






























