//
//  UIImageView+BZExtensions.m
//  GithubClientTask
//
//  Created by User on 01.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "UIImageView+BZExtensions.h"

#import "BZExtensionsManager.h"

#import <objc/runtime.h>

@interface UIView (BZExtensions_private)

@property (nonatomic, strong, nonnull) NSURLSessionDataTask *theMainImageDataTask;
@property (nonatomic, strong, nonnull) NSURLSession *theMainNSUrlSession;

@end


@implementation UIImageView (BZExtensions)

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

#pragma mark - Setters (Public)

#pragma mark - Getters (Public)

#pragma mark - Setters (Private)

- (void)setTheMainImageDataTask:(NSURLSessionDataTask * _Nonnull)theMainImageDataTask
{
    if (!theMainImageDataTask)
    {
        abort();
    }
    objc_setAssociatedObject(self, @selector(theMainImageDataTask), theMainImageDataTask, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Getters (Private)

- (NSURLSessionDataTask *)theMainImageDataTask
{
    NSURLSessionDataTask *theMainImageDataTask = objc_getAssociatedObject(self, @selector(theMainImageDataTask));
    return theMainImageDataTask;

}

- (NSURLSession *)theMainNSUrlSession
{
    NSURLSession *theMainNSUrlSession = objc_getAssociatedObject(self, @selector(theMainNSUrlSession));
    if (!theMainNSUrlSession)
    {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        theMainNSUrlSession = [NSURLSession sessionWithConfiguration:config];

        objc_setAssociatedObject(self, @selector(theMainNSUrlSession), theMainNSUrlSession, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    }
    return theMainNSUrlSession;

}

#pragma mark - Lifecycle

#pragma mark - Create Views & Variables

#pragma mark - Actions

#pragma mark - Gestures

#pragma mark - Delegates ()

#pragma mark - Methods (Public)

- (void)methodSetImageWithNSURL:(NSURL * _Nonnull)theNSURL
           withPlaceholderImage:(UIImage * _Nonnull) theImage
{
    if (!theNSURL)
    {
        abort();
    }
    if (!theImage)
    {
        abort();
    }
    self.image = theImage;
    
    if (self.theMainImageDataTask)
    {
        [self.theMainImageDataTask cancel];
    }
    self.theMainImageDataTask = [self.theMainNSUrlSession dataTaskWithURL:theNSURL
                                                   completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                            {
                                if (!data)
                                {
                                    return;
                                }
                                if (error)
                                {
                                    return;
                                }
                                UIImage *theLoadedImage = [[UIImage alloc] initWithData:data];
                                [BZExtensionsManager methodAsyncMainWithBlock:^
                                {
                                    self.image = theLoadedImage;
                                }];
                            }];
    [self.theMainImageDataTask resume];
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























