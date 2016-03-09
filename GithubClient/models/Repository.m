//
//  BZRepository.m
//  GithubClientTask
//
//  Created by User on 29.02.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import "Repository.h"

@interface Repository ()

@property (nonatomic, strong, nullable) NSString *theNameString;
@property (nonatomic, strong, nullable) NSString *theDescriptionString;
@property (nonatomic, strong, nullable) NSString *theAvatarUrlString;
@property (nonatomic, strong, nullable) NSString *theForksCountString;
@property (nonatomic, strong, nullable) NSString *theSubscribersCountString;
@property (nonatomic, strong, nullable) NSString *theSubscribersUrlString;

@end

@implementation Repository

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

- (void)methodSetRepositoryWithDictionary:(NSDictionary * _Nonnull)theRepositoryDictionary
{
    if (!theRepositoryDictionary)
    {
        abort();
    }
    if (![theRepositoryDictionary isKindOfClass:[NSDictionary class]])
    {
        abort();
    }
    id theObject = theRepositoryDictionary[@"name"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theNameString = [NSString stringWithFormat:@"%@",theObject];
    }
    theObject = theRepositoryDictionary[@"description"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theDescriptionString = [NSString stringWithFormat:@"%@",theObject];
    }
    theObject = theRepositoryDictionary[@"forks"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theForksCountString = [NSString stringWithFormat:@"%@",theObject];
    }
    theObject = theRepositoryDictionary[@"subscribers_url"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        self.theSubscribersUrlString = [NSString stringWithFormat:@"%@",theObject];
    }
    theObject = theRepositoryDictionary[@"owner"];
    if (theObject && ![theObject isEqual:[NSNull null]])
    {
        NSDictionary *theOwnerDictionary = (NSDictionary *)theObject;
        theObject = theOwnerDictionary[@"avatar_url"];
        if (theObject && ![theObject isEqual:[NSNull null]])
        {
            self.theAvatarUrlString = [NSString stringWithFormat:@"%@", theObject];
        }
    }
}

#pragma mark - Methods (Private)

#pragma mark - Standard Methods

@end






























