//
//  BZUrlSession.h
//  GithubClientTask
//
//  Created by User on 04.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BZUrlSession : NSObject

- (void)methodStop;
- (void)methodStartTaskWithUrl:(NSURL * _Nonnull)theUrl
            withCompletionBlock:(void(^ _Nullable)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))theCompletionBlock;

@end






























