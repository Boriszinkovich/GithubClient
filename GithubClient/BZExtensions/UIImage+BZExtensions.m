//
//  UIImage+BZExtensions.m
//  ScrollViewTask
//
//  Created by BZ on 2/16/16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "UIImage+BZExtensions.h"

@implementation UIImage (BZExtensions)

#pragma mark - Class Methods (Public)

+ (UIImage * _Nullable)getImageNamed:(NSString * _Nonnull)theImageName
{
    NSString *theImageResolutionNumber;
    BOOL theIsRetinaDisplay = ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]
                               && ([UIScreen mainScreen].scale >= 2.0));
    if (theIsRetinaDisplay)
    {
        theImageResolutionNumber = @"2";
    }
    else
    {
        theImageResolutionNumber = @"1";
    }
    NSString *theFileName = [NSString stringWithFormat:@"%@@%@x.png",theImageName,theImageResolutionNumber];
    UIImage *theImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:theFileName ofType:nil]];
    return theImage;
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

- (UIImage * _Nonnull)getImageScaledToSize:(CGSize)theSize;
{
    if (CGSizeEqualToSize(self.size, theSize))
    {
        return self;
    }
    
    UIImage *theNewImage = self.copy;
    UIGraphicsBeginImageContextWithOptions(theSize, NO, 0.0f);
    
    [theNewImage drawInRect:CGRectMake(0.0f, 0.0f, theSize.width, theSize.height)];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























