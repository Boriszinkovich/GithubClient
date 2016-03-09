//
//  BZSubscriber.m
//  GithubClientTask
//
//  Created by User on 01.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "Subscriber.h"

@interface Subscriber ()

@property (nonatomic, strong, nullable) NSString *theNameString;
@property (nonatomic, strong, nullable) NSString *theAvatarUrlString;

@end

@implementation Subscriber

#pragma mark - Class Methods (Public)

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

- (void)methodSetSubscriberWithDictionary:(NSDictionary * _Nonnull)theSubscriberDictionary
{
    if (!theSubscriberDictionary)
    {
        abort();
    }
    
    id theObject = theSubscriberDictionary[@"login"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theNameString = [NSString stringWithFormat:@"%@",theObject];
    }
    theObject = theSubscriberDictionary[@"avatar_url"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theAvatarUrlString = [NSString stringWithFormat:@"%@",theObject];
    }
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods


@end






























