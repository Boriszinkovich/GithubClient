//
//  BZUrlSession.m
//  GithubClientTask
//
//  Created by User on 04.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "BZUrlSession.h"

@interface BZUrlSession ()

@property (nonatomic, strong, nonnull) NSURLSessionDataTask *theMainDataTask;
@property (nonatomic, strong, nonnull) NSURLSession *theMainNSUrlSession;

@end

@implementation BZUrlSession

#pragma mark - Class Methods (Public)

#pragma mark - Class Methods (Private)

#pragma mark - Init & Dealloc

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        [self methodInitBZUrlSession];
    }
    return self;
}

- (void)methodInitBZUrlSession
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    _theMainNSUrlSession = [NSURLSession sessionWithConfiguration:config];
}

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

- (void)methodStop
{
    if (self.theMainDataTask)
    {
        [self.theMainDataTask cancel];
    }
}

- (void)methodStartTaskWithUrl:(NSURL * _Nonnull)theUrl
            withCompletionBlock:(void(^ _Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))theCompletionBlock
{
    if (!theUrl)
    {
        abort();
    }
    if (self.theMainDataTask)
    {
        [self.theMainDataTask cancel];
    }
    self.theMainDataTask = [self.theMainNSUrlSession dataTaskWithURL:theUrl
                                                        completionHandler:theCompletionBlock];
    [self.theMainDataTask resume];
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























