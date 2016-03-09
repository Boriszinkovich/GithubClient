//
//  UserService.h
//  GithubClientTask
//
//  Created by User on 04.03.16.
//  Copyright © 2016 BZ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger
{
    UserServiceErrorNoData = 1,
    UserServiceErrorWithError= 2,
    UserServiceErrorTooMuchRequests = 3,
    UserServiceErrorEnumCount = UserServiceErrorTooMuchRequests
} UserServiceError;

@class Repository;
@class Subscriber;
@interface UserService : NSObject

+ (UserService * _Nonnull)sharedInstance;

- (void)methodLoadAllRepositoriesWithPage:(NSUInteger)thePage
                                    count:(NSUInteger)theCount
                                  taskKey:(NSString * _Nonnull)theTaskKey
                               completion:(void (^ _Nonnull)(NSArray<Repository *> * _Nullable repositoriesArray, NSError * _Nullable error))theCompletionBlock;

- (void)methodLoadRepositoriesWithSearchString:(NSString * _Nonnull)theSearchString
                                          page:(NSUInteger)thePage
                                         count:(NSUInteger)theCount
                                       taskKey:(NSString * _Nonnull)theTaskKey
                                    completion:(void (^ _Nonnull)(NSArray<Repository *> * _Nullable theRepositoriesArray, NSInteger theTotalCount, NSError * _Nullable error))theCompletionBlock;

- (void)methodLoadSubscribersWithUrlString:(NSString * _Nonnull)theUrlString
                                      Page:(NSUInteger)thePage
                                     count:(NSUInteger)theCount
                                   taskKey:(NSString * _Nonnull)theTaskKey
                                completion:(void (^ _Nonnull)(NSArray<Subscriber *> * _Nullable repositoriesArray, NSError * _Nullable error))theCompletionBlock;
@end






























