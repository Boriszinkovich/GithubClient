//
//  BZSubscriber.h
//  GithubClientTask
//
//  Created by User on 01.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subscriber : NSObject

@property (nonatomic, strong, nullable, readonly) NSString *theNameString;
@property (nonatomic, strong, nullable, readonly) NSString *theAvatarUrlString;

- (void)methodSetSubscriberWithDictionary:(NSDictionary * _Nonnull)theSubscriberDictionary;

@end






























